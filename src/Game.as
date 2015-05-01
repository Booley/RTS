package {
	//Takes in commands from other classes and executes them. Also executes tick for all state-mutable objects
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import unitstuff.Base;
	import unitstuff.Bullet;
	import unitstuff.Flock;
	import unitstuff.Infantry;
	import unitstuff.Unit;
	
	import starling.display.Image;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import starling.textures.Texture;
	import starling.display.Quad;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	
	import be.dauntless.astar.core.Astar;
	import be.dauntless.astar.core.PathRequest;
	import be.dauntless.astar.core.AstarEvent;
	import be.dauntless.astar.core.AstarError;
	import be.dauntless.astar.core.IAstarTile;
	import be.dauntless.astar.basic2d.Map;
	import be.dauntless.astar.basic2d.BasicTile;
	import be.dauntless.astar.basic2d.analyzers.SmartClippingAnalyzer;
	
	import unitstuff.*;
	import screens.*;
	import pathfinding.*;
	
	public class Game extends Sprite {
		
		private static const DISTANCE_TO_TAP_UNIT:Number = 30; // max distance from a unit you can tap for it to select its flock
		private static const DISTANCE_TO_TAP_BASE:Number = 40; // max distance from a base you can tap for it to be selected
		
		public var flocks:Vector.<Flock>;
		public var bases:Vector.<Base>;
		public var selectedUnits:Vector.<Unit>;
		public var bullets:Vector.<Bullet>;
		public var capturePoints:Vector.<TurretPoint>;
		
		private var pause:Boolean = true;
		
		private var queueMenu:QueueMenu;
		private var gameOverMenu:GameOverMenu;
		public var base1:Base;
		public var base2:Base;
		
		public var map : Map;
		public var mapData:Vector.<Vector.<Tile>>;
		public var astar : Astar;
		public var mapWidth:int;
		public var mapHeight:int;
		private var pathfindingFlock:Flock;
		public var obstaclePoints:Vector.<Point>;
		
		private var background:Image;
		
		public var multiplayer:Multiplayer;
		public var dictionary:Dictionary;
		
		public function Game() {
			super();
			
			flocks = new Vector.<Flock>();
			bases = new Vector.<Base>();
			bullets = new Vector.<Bullet>();
			capturePoints = new Vector.<TurretPoint>();
			dictionary = new Dictionary();
			
			this.addEventListener(NavEvent.GAME_OVER_LOSE, onGameOverLose);
			this.addEventListener(NavEvent.GAME_OVER_WIN, onGameOverWin);
			
			testMap();
			
			test();
			
			//var glow:BlurFilter = BlurFilter.createGlow(0xaaffff, 0.5, 0.5, 0.5);
			//this.filter = glow;
			
			// END TESTING UNIT MOVEMENT }}}}}}}}}}}}}}}}}}
			
			multiplayer = new Multiplayer();
		}
		
		public function createSignalHandler():void {
			multiplayer.game = this;
			multiplayer.signals.game = this;
		}
		
		public function testMap():void {
			// get map background
			background = new Image(Assets.getTexture("Map1Background"));
			background.width = Constants.SCREEN_WIDTH;
			background.height =  Constants.SCREEN_HEIGHT;
			addChildAt(background, 0);
			
			obstaclePoints = new Vector.<Point>();
			mapData = MapGen.getMapObstacles(MapGen.Map1Obstacles);
			mapWidth = mapData[0].length;
			mapHeight = mapData.length;
			map = new Map(mapWidth, mapHeight);
			for(var y:Number = 0; y < mapData.length; y++) {
				for(var x:Number = 0; x < mapData[y].length; x++) {
					map.setTile(mapData[y][x].basicTile);
					if (mapData[y][x].basicTile.getCost() == Tile.WALL) {
						obstaclePoints.push(indexToPos(new Point(x, y)));
					}
				}
			}
			
			//create the Astar instance and add the listeners
			astar = new Astar();
			astar.addEventListener(AstarEvent.PATH_FOUND, onPathFound);
			astar.addEventListener(AstarEvent.PATH_NOT_FOUND, onPathNotFound);
			
			//a general analyzer
			astar.addAnalyzer(new SmartClippingAnalyzer());
		}
		
		// starts pathfinding for the flock towards the endPoint.  onPathFound is called when this successfully finds a path.
		public function getGoals(flock:Flock, endPoint:Point):void {
			//create a new PathRequest
			try {
				var startTile:IAstarTile = IAstarTile(map.getTileAt(posToIndex(flock.getAvgPos())));
				var endTile:IAstarTile = IAstarTile(map.getTileAt(posToIndex(endPoint)));
				var req:PathRequest = new PathRequest(startTile, endTile, map);
				pathfindingFlock = flock;
				astar.getPath(req);
			} catch (e:AstarError) {
				
			}
		}
		
		// convert position in pixels to map coordinates for pathfinding
		public function posToIndex(p:Point):Point {
			return new Point(int(mapWidth * p.x / Constants.SCREEN_WIDTH), int(mapHeight * p.y / Constants.SCREEN_HEIGHT));
		}
			
		// convert position in pixels to map coordinates for pathfinding
		public function indexToPos(p:Point):Point {
			return new Point((p.x + 0.5)/ mapWidth * Constants.SCREEN_WIDTH, (p.y + 0.5) / mapHeight * Constants.SCREEN_HEIGHT);
		}
 
		private function onPathNotFound(event:AstarEvent):void {
			trace("path not found");
		}
 
		private function onPathFound(event:AstarEvent):void {
			var path:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < event.result.path.length; i++) {
				path.unshift((event.result.path[i] as BasicTile).getPosition());
				//trace("x: " + path[0].x + ", y: " + path[0].y);
			}
			if (pathfindingFlock) {
				pathfindingFlock.setGoals(path);
			}
		}
		
		public function onGameOverLose(event:NavEvent):void {
			pause = true;
			gameOverMenu = new GameOverMenu(2);
			addChild(gameOverMenu);
		}
		
		public function onGameOverWin(event:NavEvent):void {
			pause = true;
			gameOverMenu = new GameOverMenu(1);
			addChild(gameOverMenu);
		}
		
		private function test():void {
			// TESTING UNIT MOVEMENT AND STUFF {{{{{{{{{{{{{{{{
			// TEAM 1
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for (var i:int = 0; i < 1; i++) {
				var x:Number = Math.random() * 100 + 30;
				var y:Number = Math.random() * 100 + 300;
				var unit:Unit = new Infantry(new Point(x, y));
				unitVector.push(unit);
				addChild(unit);
				addToDictionary(unit);
			}
			var flock:Flock = new Flock(unitVector)
			getGoals(flock, new Point(200, 300));
			flocks.push(flock);
			
			// TEAM 2
			unitVector = new Vector.<Unit>();
			for (i = 0; i < 20; i++) {
				x = Math.random() * 70 + 30;
				y = Math.random() * 70 + 30;
				unit = new Infantry(new Point(x, y), 2);
				unitVector.push(unit);
				addChild(unit);
				addToDictionary(unit);
			}
			flock = new Flock(unitVector);
			getGoals(flock, new Point(200, 100));
			flocks.push(flock);
			
			flock = new Flock(unitVector);
			flocks.push(flock);
			
			base1 = new Base(new Point(Constants.SCREEN_WIDTH / 2, Constants.SCREEN_HEIGHT - 20));
			bases.push(base1);
			addChild(base1);
			addToDictionary(base1);
			queueMenu = new QueueMenu(base1);
			
			base2 = new Base(new Point(Constants.SCREEN_WIDTH / 2, 20), 2, Math.PI);
			bases.push(base2)
			addChild(base2);
			
			var turret:TurretPoint = new TurretPoint(new Point(320 / 4, 80), 2);
			//turret = new TurretPoint(new Point(320 / 4, 80), 2);
			capturePoints.push(turret);
			addChild(turret);
			addToDictionary(base2);
		}
		
		public function addToDictionary(u:Unit):void {
			dictionary[u.id] = u;
		}
		
		public function removeFromDictionary(u:Unit):void {
			delete dictionary[u.id];
		}
		
		public function start():void {
			pause = false;
		}
		
		public function end():void {
			pause = true;
		}
		
		public function tick(dt:Number):void {
			if (pause) return;
			for each (var turret:TurretPoint in capturePoints) {
				turret.tick(dt);
				
			}
			
			for each (var base:Base in bases) {
				base.tick(dt);
			}
			for each (var bullet:Bullet in bullets) {
				bullet.tick(dt);
			}
			for each (var flock:Flock in flocks) {
				flock.tick(dt);
			}
			if (this.contains(queueMenu)) {
				queueMenu.tick(dt);
			}
			// remove bullets which have hit an obstacle
			for each (bullet in bullets) {
				var pos:Point = posToIndex(bullet.pos);
				if (pos.x >= 0 && pos.x < mapData[0].length && pos.y >= 0 && pos.y < mapData.length) {
					if (mapData[pos.y][pos.x].basicTile.getCost() == Tile.WALL) {
						removeBullet(bullet);
					}
				}
			}
			
		}
		
		public function handleTap(startX:int, startY:int, endX:int, endY:int):void {
			var startTap:Point = new Point(startX, startY);
			var endTap:Point = new Point(endX, endY);
			
			if (contains(queueMenu)) {
				removeChild(queueMenu);
			}
			// if units were selected from a previous tap or drag
			if (selectedUnits && selectedUnits.length > 0) {
				var newFlock:Flock = new Flock();
				for each (var unit:Unit in selectedUnits) {		
					// remove unit from old flock
					var oldFlock:Flock = unit.flock;
					if (oldFlock) {
						oldFlock.removeUnit(unit);
						if (oldFlock.units.length == 0) {
							flocks.splice(flocks.indexOf(oldFlock), 1);
						}
					}
					newFlock.addUnit(unit);
					unit.unHighlight();
				}
				if (newFlock.units.length > 0) {
					getGoals(newFlock, startTap)
					flocks.push(newFlock); 
				} else {
					trace("Empty flock error");
				}
				
				selectedUnits = null;
				return;
			}
			// if no units are currently selected,
			// check if the base was clicked
			if (base1.pos.subtract(startTap).length < DISTANCE_TO_TAP_BASE) {
				addChild(queueMenu);
				return;
			} 
			//select the nearest flock
			var bestDist:int = DISTANCE_TO_TAP_UNIT;
			var closestFlock:Flock;
			for each (var flock:Flock in flocks) {
				for each (unit in flock.units) {
					var thisDist:int = unit.pos.subtract(startTap).length;
					if (thisDist < bestDist) {
						bestDist = thisDist;
						closestFlock = unit.flock;
					}
				}
			}
			if (closestFlock) {
				selectUnits(closestFlock.units);
			}
		}
		
		// tap to select A FLOCK. Return true if a flock was selected.
		public function tap(startTap:Point, endTap:Point):void {
			//multiplayer.sendPlayerTapped(startTap, endTap);
			
			if (contains(queueMenu)) {
				removeChild(queueMenu);
			}
			// if units were selected from a previous tap or drag
			if (selectedUnits) {
				var newFlock:Flock = new Flock();
				for each (var unit:Unit in selectedUnits) {		
					var oldFlock:Flock = unit.flock;
					if (oldFlock) {
						oldFlock.removeUnit(unit);
						if (oldFlock.units.length == 0) {
							flocks.splice(flocks.indexOf(oldFlock), 1);
						}
					}
					newFlock.addUnit(unit);
					unit.unHighlight();
				}
				if (newFlock.units.length > 0) {
					getGoals(newFlock, startTap);
					flocks.push(newFlock); 
					
					multiplayer.sendMovement(idsToString(newFlock.units), startTap);
				} else {
					trace("Empty flock error");
				}
				
				selectedUnits = null;
				return;
			}
			// if no units are currently selected,
			// check if the base was clicked
			if (base1.pos.subtract(startTap).length < DISTANCE_TO_TAP_BASE) {
				addChild(queueMenu);
				return;
			} 
			//select the nearest flock
			var bestDist:int = DISTANCE_TO_TAP_UNIT;
			var closestFlock:Flock;
			for each (var flock:Flock in flocks) {
				for each (unit in flock.units) {
					var thisDist:int = unit.pos.subtract(startTap).length;
					if (thisDist < bestDist) {
						bestDist = thisDist;
						closestFlock = unit.flock;
					}
				}
			}
			if (closestFlock) {
				selectUnits(closestFlock.units);
			}
		}
		
		// drag to box-select UNITS. Return true if units were selected.
		public function drag(startTap:Point, endTap:Point):void {
			if (contains(queueMenu)) {
				removeChild(queueMenu);
			}
			// deselect any currently selected units
			if (selectedUnits) {
				for each (unit in selectedUnits) {
					unit.unHighlight();
				}
				selectedUnits = null;
			}
			// determine which units were inside the box selection
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.units) {
					if (containsPoint(startTap, endTap, unit.pos)) {
						if (unit.owner == 1) {
							unitVector.push(unit);
						}
					}
				}
			}
			// if units were selected, select them
			if (unitVector.length > 0) {
				selectUnits(unitVector);
			} 
		}
		
		// is the middle point in the rectangle defined by p1 and p2?
		private function containsPoint(p1:Point, p2:Point, middle:Point):Boolean {
			var x1:Number = Math.min(p1.x, p2.x);
			var y1:Number = Math.min(p1.y, p2.y);
			var x2:Number = Math.max(p1.x, p2.x);
			var y2:Number = Math.max(p1.y, p2.y);
			var rect:Rectangle = new Rectangle(x1, y1, x2 - x1, y2 - y1);
			return rect.containsPoint(middle);
		}
		
		// select flock from either select or boxSelect
		private function selectUnits(unitVector:Vector.<Unit>):void {
			for each (var unit:Unit in unitVector) {
				unit.highlight();
			}
			selectedUnits = unitVector.slice(0, unitVector.length);
		}
		
		public function getEnemyUnits(owner:int):Vector.<Unit> {
			// determine which units were inside the box selection
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.units) {
					if (unit.owner != owner) {
						unitVector.push(unit);
					} else {
						break;
					}
				}
			}
			for each (var base:Base in bases) {
				if (base.owner != owner) {
					unitVector.push(base);
				}
			}
			
			for each (var turret:TurretPoint in capturePoints) {
				if (turret.owner != owner) {
					unitVector.push(turret);
				}
				
			}
			
			return unitVector;
		}
		
		public function getOtherFlockUnits(thisUnit:Unit):Vector.<Unit> {
			// determine which units were inside the box selection
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.units) {
					if (!(unit.flock === thisUnit.flock)) {
						unitVector.push(unit);
					} else {
						break;
					}
				}
			}
			for each (var base:Base in bases) {
				unitVector.push(base);
			}
			return unitVector;
		}
		
		public function spawn(unitType:int, pos:Point, owner:int, rotation:Number):Unit {
			var unit:Unit;
			var unitClass:Class = Unit.getClass(unitType);
			if (unitClass) {
				unit = new unitClass(pos, owner, rotation);
				var unitVector:Vector.<Unit> = new Vector.<Unit>();
				unitVector.push(unit);
				addChild(unit);
				var flock:Flock = new Flock(unitVector);
				getGoals(flock, new Point(200, 200));
				flocks.push(flock);
				addToDictionary(unit);
				return unit;
			}
			return null;
		}
		
		// convert unit vector to string array to send in multiplayer game
		public function idsToString(unitVector:Vector.<Unit>):String {
			var idString:String = "";
			for each (var unit:Unit in unitVector) {
				idString += unit.id + " ";
			}
			idString = idString.substr(0, idString.length - 1);
			return idString;
		}
		
		// conver a string of unit ids into a flock full of units
		public function idStringToUnitVector(string:String):Vector.<Unit> {
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for each (var idString:String in string.split(" ")) {
				var id:int = parseInt(idString);
				if (id >= 0) {
					var unit:Unit = dictionary[id];
					unitVector.push(unit);
				}
			}
			return unitVector;
		}
		
		public function removeUnit(unit:Unit):void {
			if (unit == null) {
				return;
			}
			removeFromDictionary(unit);
			var flock:Flock = unit.flock;
			if (unit.flock != null) {
				// remove unit from its flock
				flock.removeUnit(unit);
				if (flock.units.length == 0) {
					flocks.splice(flocks.indexOf(flock), 1);
				}
			}
			if (contains(unit)) {
				removeChild(unit);
			}
			
			// make sure unit isn't in selectedUnits
			for each (var unit2:Unit in selectedUnits) {
				if (unit.id == unit2.id) {
					selectedUnits.splice(selectedUnits.indexOf(unit), 1);
				}
			}
			// remove any bullets headed toward this unit
			for each (var bullet:Bullet in bullets) {
				// === compares memory addresses
				if (bullet.target == unit) {
					removeBullet(bullet);
				}
			}
			
			// if unit is a base
			if (unit.owner == 1) {
				dispatchEvent(new NavEvent(NavEvent.GAME_OVER_LOSE));
			} else {
				dispatchEvent(new NavEvent(NavEvent.GAME_OVER_WIN));
			}
		}

		public function addBullet(bullet:Bullet):void {
			bullets.push(bullet);
			addChild(bullet);
		}
		
		public function removeBullet(bullet:Bullet):void {
			bullets.splice(bullets.indexOf(bullet), 1)
			removeChild(bullet);
		}
		
				
		// given an owner, return a string encoded with all of their units' ids + positions
		public function getUnitMovementString(owner:int):String {
			var s:String = "";
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.units) {
					if (unit.owner == owner) {
						 s += unit.id + ",";
						 s += unit.pos.x + ",";
						 s += unit.pos.y + ";";
					} else {
						break;
					}
				}
			}
			s = s.substr(0, s.length - 1); // don't include final ";" to parse correctly
			return s;
		}
		
		// given the string with id + position data, update the units' positions
		public function updateUnitsFromMovementString(s:String):void {
			var unitDatas:Array = s.split(";");
			for each (var unitDataString:String in unitDatas) {
				var unitData:Array = unitDataString.split(",");
				var unit:Unit = dictionary[int(unitData[0])];
				if (unit != null) {
					var pos:Point = new Point(int(unitData[1]), int(unitData[2]));
					unit.pos = pos;
				}
			}
		}
	}
}