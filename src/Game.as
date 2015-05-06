package {
	//Takes in commands from other classes and executes them. Also executes tick for all state-mutable objects
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.text.TextField;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import starling.textures.Texture;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	
	import be.dauntless.astar.core.Astar;
	import be.dauntless.astar.core.PathRequest;
	import be.dauntless.astar.core.AstarEvent;
	import be.dauntless.astar.core.AstarError;
	import be.dauntless.astar.core.IAstarTile;
	import be.dauntless.astar.basic2d.Map;
	import be.dauntless.astar.basic2d.BasicTile;
	
	import unitstuff.*;
	import screens.*;
	import pathfinding.*;
	import ai.AI;
	
	public class Game extends Sprite {
		
		private static const DISTANCE_TO_TAP_UNIT:Number = 30; // max distance from a unit you can tap for it to select its flock
		private static const DISTANCE_TO_TAP_BASE:Number = 40; // max distance from a base you can tap for it to be selected

		public var flocks:Vector.<Flock>;
		public var bases:Vector.<Base>;
		public var selectedUnits:Vector.<Unit>;
		public var bullets:Vector.<Bullet>;
		public var turretPoints:Vector.<TurretPoint>;
		public var resourcePoints:Vector.<ResourcePoint>;
		
		private var pause:Boolean = true;
		
		// AI stuff
		private var nextUnitTypeChosen:Boolean = false;
		private var nextUnitType:int;
		public var difficulty:int = AI.EASY;
		
		private var queueMenu:QueueMenu;
		private var gameOverMenu:GameOverMenu;
		public var base1:Base;
		public var base2:Base;
		
		public var map:Map;
		public var mapData:Vector.<Vector.<Tile>>;
		public var astar:Astar;
		public var mapWidth:int;
		public var mapHeight:int;
		private var mapWidthFactor:Number;
		private var mapHeightFactor:Number;
		private var pathfindingFlock:Flock;
		public var obstaclePoints:Vector.<Point>;
		
		private var background:Image;
		
		public var multiplayer:Multiplayer;
		public var dictionary:Dictionary;
		
		public var currentPlayer:int = 1;
		private var waitingRoom:WaitingRoom;
		private static var tickCounter:int = 0;
		
		private var scoreText:TextField;
		private var resourceText:TextField;
		
		public function Game() {
			super();
			//waitingRoom = new WaitingRoom();
			
			flocks = new Vector.<Flock>();
			bases = new Vector.<Base>();
			bullets = new Vector.<Bullet>();
			turretPoints = new Vector.<TurretPoint>();
			resourcePoints = new Vector.<ResourcePoint>();
			dictionary = new Dictionary();
			
			this.addEventListener(NavEvent.GAME_OVER_LOSE, onGameOverLose);
			this.addEventListener(NavEvent.GAME_OVER_WIN, onGameOverWin);
		
			testMap();
			
			scoreText = new TextField(100, 30, "Score: " + 0, "Verdana", 12, 0xffffff, true);
			scoreText.y = 0;
			scoreText.x = 200;
			
			//customize resource display button
			resourceText = new TextField(100, 30, "Gold: " + Base.DEFAULT_TOTAL_RESOURCES, "Verdana", 12, 0xffffff, true);
			resourceText.y = 0;
			resourceText.x = 200;
			
			//addChild(scoreText);
			
			addChild(resourceText);
			
			// END TESTING UNIT MOVEMENT }}}}}}}}}}}}}}}}}}
			
			multiplayer = new Multiplayer();
		}
		
		public function createSignalHandler():void {
			//multiplayer.game = this;
			//multiplayer.signals.game = this;
		}
		
		public function testMap():void {
			// get map background
			background = new Image(Assets.getAtlas().getTexture(Assets.Map1Background));
			background.width = Constants.SCREEN_WIDTH;
			background.height =  Constants.SCREEN_HEIGHT;
			addChildAt(background, 0);
			
			obstaclePoints = new Vector.<Point>();
			mapData = MapGen.getMapObstacles(Assets.Map1Obstacles, this);
			mapWidth = mapData[0].length;
			mapHeight = mapData.length;
			mapWidthFactor = Constants.SCREEN_WIDTH / mapWidth;
			mapHeightFactor = Constants.SCREEN_HEIGHT / mapHeight;
			map = new Map(mapWidth, mapHeight);
			for(var y:Number = 0; y < mapData.length; y++) {
				for(var x:Number = 0; x < mapData[y].length; x++) {
					map.setTile(mapData[y][x].basicTile);
					if (mapData[y][x].basicTile.getCost() == Tile.WALL) {
						obstaclePoints.push(indexToPos(new Point(x, y)));
					}
					if (mapData[y][x].type == MapGen.NEUTRAL_CAPTURE_POINT) {
						addResourcePoint(new ResourcePoint(indexToPos(new Point(x, y)), 3));
					}
					if (mapData[y][x].type == MapGen.RED_CAPTURE_POINT) {
						addResourcePoint(new ResourcePoint(indexToPos(new Point(x, y)), 2));
					}
					if (mapData[y][x].type == MapGen.BLUE_CAPTURE_POINT) {
						addResourcePoint(new ResourcePoint(indexToPos(new Point(x, y)), 1));
					}
				}
			}
			
			base1 = new Base(new Point(Constants.SCREEN_WIDTH / 2, Constants.SCREEN_HEIGHT - 20));
			bases.push(base1);
			addChild(base1);
			addToDictionary(base1);
			
			base2 = new Base(new Point(Constants.SCREEN_WIDTH / 2, 20), 2, Math.PI);
			bases.push(base2)
			addChild(base2);
			addToDictionary(base2);
			
			//create the Astar instance and add the listeners
			astar = new Astar();
			astar.addEventListener(AstarEvent.PATH_FOUND, onPathFound);
			astar.addEventListener(AstarEvent.PATH_NOT_FOUND, onPathNotFound);
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
			return new Point(int(p.x / mapWidthFactor), int(p.y / mapHeightFactor));
		}
			
		// convert position in pixels to map coordinates for pathfinding
		public function indexToPos(p:Point):Point {
			return new Point((p.x + 0.5) * mapWidthFactor, (p.y + 0.5) * mapHeightFactor);
		}
 
		private function onPathNotFound(event:AstarEvent):void {
			trace("path not found");
		}
 
		private function onPathFound(event:AstarEvent):void {
			var path:Vector.<Point> = new Vector.<Point>();
			for (var i:int = event.result.path.length - 1; i >= 0; i--) {
				path.push((event.result.path[i] as BasicTile).getPosition());
			}
			if (pathfindingFlock) {
				pathfindingFlock.setGoals(path);
			}
		}
		
		public function getUserBase(player:int):Base {
			if (player == 1) {
				return base1;
			}
			else {
				return base2;
			}
		}
		
		public function onGameOverLose(event:Event):void {
			pause = true;
			gameOverMenu = new GameOverMenu(false);
			addChild(gameOverMenu);
		}
		
		public function onGameOverWin(event:Event):void {
			pause = true;
			gameOverMenu = new GameOverMenu(true);
			addChild(gameOverMenu);
		}
		
		public function start():void {
			pause = false;
		}
		
		public function end():void {
			pause = true;
		}
		
		public function doAI():void {
			var AIOwner:int = 1;
			var AIBase:Base = base1;
			var AIEnemyBase:Base = base2;
			if (AIOwner == currentPlayer) {
				AIOwner = 2;
				AIBase = base2;
				AIEnemyBase = base1;
			}
			// queue next unit
			
			if (AIBase.unitBuildCooldown < 0) {
				if (!nextUnitTypeChosen) {
					nextUnitType = AI.getUnitBuildCommand(difficulty, AIOwner, flocks, mapData, resourcePoints, AIBase, AIEnemyBase);
					nextUnitTypeChosen = true;
				}
				var penaltyFactor:int = 1;
				if (difficulty == AI.EASY) penaltyFactor = 1.5;
				if (difficulty == AI.MEDIUM) penaltyFactor = 1.4;
				if (AIBase.totalResources >= Unit.getClass(nextUnitType).COST*penaltyFactor) {
					AIBase.totalResources -= Unit.getClass(nextUnitType).COST*penaltyFactor;
					AIBase.queueUnit(nextUnitType);
					nextUnitTypeChosen = false;
				}
			}
			
			// do unit movement
			AI.getUnitMovementCommand(difficulty, AIOwner, flocks, mapData, resourcePoints, AIBase, AIEnemyBase);
		}
		
		public function tick(dt:Number):void {
			dt *= 5;
			if (pause) return;

			if (PlayScreen.isMultiplayer && !multiplayer.isConnected && !multiplayer.opponentIsConnected) return;
			
			for each (var flock:Flock in flocks) {
				if (flock.units.length == 0) {
					flocks.splice(flocks.indexOf(flock), 1);
				}
			}
			
			// try to spawn units if AI
			if (!PlayScreen.isMultiplayer) {
				doAI();
			}
			
			for each (flock in flocks) {
				flock.tick(dt);
			}
			for each (var turret:TurretPoint in turretPoints) {
				turret.tick(dt);
			}
			for each (var rp:ResourcePoint in resourcePoints) {
				rp.tick(dt);
			}
			for each (var base:Base in bases) {
				base.tick2(dt, resourcePoints);
				if (base.owner == this.currentPlayer) {
					resourceText.text = "Gold: " + int(base.totalResources); 
					scoreText.text = "Score: " + base.score;
				}
			}
			for each (var bullet:Bullet in bullets) {
				bullet.tick(dt);
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
		
		// tap to select A FLOCK. Return true if a flock was selected.
		public function tap(startTap:Point, endTap:Point):void {
			if (contains(queueMenu)) {
				removeChild(queueMenu);
			}
			if (pause) return;
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
					flocks.push(newFlock); 
					
					var bestDist:int = DISTANCE_TO_TAP_UNIT;
					var closestUnit:Unit;
					// test for force-targeting on a unit
					var unitList:Vector.<Unit> = getOtherFlockUnits(newFlock.units[0]);
					for each (unit in unitList) {
						// target enemy units only
						if (this.currentPlayer != unit.owner) {
							var thisDist:int = unit.pos.subtract(startTap).length;
							if (thisDist < bestDist) {
								bestDist = thisDist;
								closestUnit = unit;
							}
						}
					}
					if (closestUnit) {
						for each (unit in selectedUnits) {
							unit.target = closestUnit;
							// FORCE-TARGETING SHOULD BE SYNCED
						}
					}
				
					getGoals(newFlock, startTap);
					multiplayer.sendMovement(idsToString(newFlock.units), startTap);
				} else {
					trace("Empty flock error");
				}
				
				selectedUnits = null;
				return;
			}
			// if no units are currently selected,
			// check if the base was clicked
			var yourBase:Base;
			if (this.currentPlayer == 1) {
				yourBase = base1;
			} else {
				yourBase = base2;
			}
			if (yourBase.pos.subtract(startTap).length < DISTANCE_TO_TAP_BASE) {
				queueMenu = new QueueMenu(yourBase);
				addChild(queueMenu);
				return;
			} 
			//select the nearest flock
			bestDist = DISTANCE_TO_TAP_UNIT;
			var closestFlock:Flock;
			for each (var flock:Flock in flocks) {
				for each (unit in flock.units) {
					if (unit.unitType == Unit.RESOURCE_POINT) break;
					if (this.currentPlayer != unit.owner) break;
					thisDist = unit.pos.subtract(startTap).length;
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
			if (pause) return;
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
						if (unit.unitType == Unit.RESOURCE_POINT) break;
						if (unit.owner == this.currentPlayer) {
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
		
		public function getEnemyUnitIDs(owner:int):Vector.<int> {
			var unitVector:Vector.<int> = new Vector.<int>();
			
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.units) {
					if (unit.owner != owner) {
						unitVector.push(unit.id);
					} else {
						break;
					}
				}
			}
			for each (var base:Base in bases) {
				if (base.owner != owner) {
					unitVector.push(base.id);
				}
			}
			
			for each (var turret:TurretPoint in turretPoints) {
				if (turret.owner != owner) {
					unitVector.push(turret.id);
				}
			}
			
			for each (var rp:ResourcePoint in resourcePoints) {
				if (rp.owner != owner) {
					unitVector.push(rp.id);
				}
			}
			
			return unitVector;
		}
		
		// units to be repelled
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
			for each (var rp:ResourcePoint in resourcePoints) {
				unitVector.push(rp);
			}
			return unitVector;
		}
		
		public function spawn(unitType:int, pos:Point, owner:int, rotation:Number):Unit {
			var unit:Unit;
			var unitClass:Class = Unit.getClass(unitType);
			if (unitClass) {
				if (rotation != Math.PI/2) {
					unit = new unitClass(pos.add(new Point(10*(Math.random() - 0.5), -10)), owner, rotation);
				} else {
					unit = new unitClass(pos.add(new Point(10*(Math.random() - 0.5), 10)), owner, rotation);
				}
				
				var unitVector:Vector.<Unit> = new Vector.<Unit>();
				unitVector.push(unit);
				addChild(unit);
				var flock:Flock = new Flock(unitVector);
				if (rotation != Math.PI/2) {
					getGoals(flock, getUserBase(owner).pos.add(new Point(0, -100)));
				} else {
					getGoals(flock, getUserBase(owner).pos.add(new Point(0, 100)));
				}
				
				flocks.push(flock);
				addToDictionary(unit);
				return unit;
			}
			return null;
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
			
			if (unit is Base) {
				bases.splice(bases.indexOf(Base(unit)), 1);
				if (unit.owner == currentPlayer) {
					dispatchEventWith(NavEvent.GAME_OVER_LOSE);
				} else {
					dispatchEventWith(NavEvent.GAME_OVER_WIN);
					
				}
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
		
		public function addResourcePoint(p:ResourcePoint):void {
			resourcePoints.push(p);
			addToDictionary(p);
			addChild(p);
		}
		
		public function removeResourcePoint(p:ResourcePoint):void {
			resourcePoints.splice(resourcePoints.indexOf(p), 1);
			removeFromDictionary(p);
			removeChild(p);
		}
			
		public function addToDictionary(u:Unit):void {
			dictionary[u.id] = u;
		}
		
		public function removeFromDictionary(u:Unit):void {
			delete dictionary[u.id];
		}
		
		//////////////////////////// MULTIPLAYER STRING CONVERSION ////////////////////////////////////
		
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
					var diff:Point = pos.subtract(unit.pos);
					var DECAY_RATE:Number = 0.5;
					diff.normalize(diff.length * DECAY_RATE);
					unit.pos = unit.pos.add(diff);
				}
			}
		}
	}
}