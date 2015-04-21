package {
	//Takes in commands from other classes and executes them. Also executes tick for all state-mutable objects
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
	import be.dauntless.astar.basic2d.analyzers.WalkableAnalyzer;
	
	import units.*;
	import screens.QueueMenu;
	import screens.GameOverMenu;
	import pathfinding.*;
	
	public class Game extends Sprite {
		
		private static const DISTANCE_TO_TAP_UNIT:Number = 30; // max distance from a unit you can tap for it to select its flock
		private static const DISTANCE_TO_TAP_BASE:Number = 40; // max distance from a unit you can tap for it to select its flock
		
		private var flocks:Vector.<Flock>;
		private var bases:Vector.<Base>;
		private var selectedUnits:Vector.<Unit>;
		private var bullets:Vector.<Bullet>;
		
		private var pause:Boolean = true;
		
		private var queueMenu:QueueMenu;
		private var gameOverMenu:GameOverMenu;
		private var base1:Base;
		private var base2:Base;
		
		private var map : Map;
		private var astar : Astar;
		private var req:PathRequest;
		
		private var multiplayer:Multiplayer;
		
		public function Game() {
			super();
			
			flocks = new Vector.<Flock>();
			bases = new Vector.<Base>();
			bullets = new Vector.<Bullet>();
			
			this.addEventListener(NavEvent.GAME_OVER_LOSE, onGameOverLose);
			this.addEventListener(NavEvent.GAME_OVER_WIN, onGameOverWin);
			
			test();
			
			testStuff();
			
			// the blur filter handles also drop shadow and glow
			var blur:BlurFilter = new BlurFilter();
			var dropShadow:BlurFilter = BlurFilter.createDropShadow();
			var glow:BlurFilter = BlurFilter.createGlow(0xaaffff, 0.5, 0.5, 0.5);

			// the ColorMatrixFilter contains some handy helper methods
			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
			colorMatrixFilter.invert();                // invert image
			colorMatrixFilter.adjustSaturation(-1);    // make image Grayscale
			colorMatrixFilter.adjustContrast(0.75);    // raise contrast
			colorMatrixFilter.adjustHue(1);            // change hue
			colorMatrixFilter.adjustBrightness(-0.25); // darken image

			// to use a filter, just set it to the "filter" property
			this.filter = glow;
			
			// END TESTING UNIT MOVEMENT }}}}}}}}}}}}}}}}}}
			
			multiplayer = new Multiplayer();
		}
		
		public function testStuff():void {
			
			var mapData:Vector.<Vector.<Tile>> = MapGen.map1();
			map = new Map(mapData[0].length, mapData.length);
			for(var y:Number = 0; y < mapData.length; y++) {
				for(var x:Number = 0; x < mapData[y].length; x++) {
					map.setTile(mapData[y][x].basicTile);
				}
			}
 
			//create the Astar instance and add the listeners
			astar = new Astar();
			astar.addEventListener(AstarEvent.PATH_FOUND, onPathFound);
			astar.addEventListener(AstarEvent.PATH_NOT_FOUND, onPathNotFound);
 
			//create a new PathRequest
			req = new PathRequest(IAstarTile(map.getTileAt(new Point(0, 0))), IAstarTile(map.getTileAt(new Point(0, 13))), map);
 
			//a general analyzer
			astar.addAnalyzer(new WalkableAnalyzer());
			astar.getPath(req);
		}
 
		private function onPathNotFound(event : AstarEvent) : void
		{
			trace("path not found");
		}
 
 
		private function onPathFound(event : AstarEvent):void {
			trace("Path was found: ");
			for(var i:int = 0; i < event.result.path.length;i++) {
				trace((event.result.path[i] as BasicTile).getPosition());
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
			for (var i:int = 0; i < 20; i++) {
				var x:Number = Math.random() * 100;
				var y:Number = Math.random() * 100 + 400;
				var unit:Unit = new Infantry(new Point(x, y));
				unitVector.push(unit);
				addChild(unit);
			}
			var flock:Flock = new Flock(unitVector);
			flocks.push(flock);
			flock.goal = new Point(200, 300);
			
			// TEAM 2
			unitVector = new Vector.<Unit>();
			for (i = 0; i < 20; i++) {
				x = Math.random() * 100;
				y = Math.random() * 100;
				unit = new Infantry(new Point(x, y), 2);
				unitVector.push(unit);
				addChild(unit);
			}
			
			flock = new Flock(unitVector);
			flocks.push(flock);
			flock.goal = new Point(200, 100);
			
			unitVector = new Vector.<Unit>();
			for (i = 0; i < 20; i++) {
				x = i * 10;
				y =  200;
				if (i % 4 == 0) {
					i += 1;
				}
				unit = new Obstacle(new Point(x, y), 2);
				unitVector.push(unit);
				addChild(unit);
			}
			
			flock = new Flock(unitVector);
			flocks.push(flock);
			
			
			base1 = new Base(new Point(320 / 2, 480 - 10));
			bases.push(base1);
			addChild(base1);
			queueMenu = new QueueMenu(base1);
			
			base2 = new Base(new Point(320 / 2, 10), 2, Math.PI);
			bases.push(base2)
			addChild(base2);
		}
		
		public function start():void {
			pause = false;
		}
		
		public function end():void {
			pause = true;
		}
		
		public function tick(dt:Number):void {
			if (pause) return;
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
		}
		
		public function handleTap(startX:int, startY:int, endX:int, endY:int):void {
			var startTap:Point = new Point(startX, startY);
			var endTap:Point = new Point(endX, endY);
			
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
						if (oldFlock.neighbors.length == 0) {
							flocks.splice(flocks.indexOf(oldFlock), 1);
						}
					}
					newFlock.addUnit(unit);
					unit.unHighlight();
				}
				if (newFlock.neighbors.length > 0) {
					newFlock.goal = startTap;
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
				for each (unit in flock.neighbors) {
					var thisDist:int = unit.pos.subtract(startTap).length;
					if (thisDist < bestDist) {
						bestDist = thisDist;
						closestFlock = unit.flock;
					}
				}
			}
			if (closestFlock) {
				selectUnits(closestFlock.neighbors);
			}
		}
		
		// tap to select A FLOCK. Return true if a flock was selected.
		public function tap(startTap:Point, endTap:Point):void {
			multiplayer.sendPlayerTapped(startTap, endTap);
			
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
						if (oldFlock.neighbors.length == 0) {
							flocks.splice(flocks.indexOf(oldFlock), 1);
						}
					}
					newFlock.addUnit(unit);
					unit.unHighlight();
				}
				if (newFlock.neighbors.length > 0) {
					newFlock.goal = startTap;
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
				for each (unit in flock.neighbors) {
					var thisDist:int = unit.pos.subtract(startTap).length;
					if (thisDist < bestDist) {
						bestDist = thisDist;
						closestFlock = unit.flock;
					}
				}
			}
			if (closestFlock) {
				selectUnits(closestFlock.neighbors);
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
				for each (var unit:Unit in flock.neighbors) {
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
				for each (var unit:Unit in flock.neighbors) {
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
			return unitVector;
		}
		
		public function getOtherFlockUnits(thisUnit:Unit):Vector.<Unit> {
			// determine which units were inside the box selection
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.neighbors) {
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
		
		public function spawn(unitType:int, pos:Point, owner:int, rotation:Number):void {
			var unit:Unit;
			var unitClass:Class = Unit.getClass(unitType);
			if (unitClass) {
				unit = new unitClass(pos, owner, rotation);
				var unitVector:Vector.<Unit> = new Vector.<Unit>();
				unitVector.push(unit);
				addChild(unit);
				var flock:Flock = new Flock(unitVector);
				flock.goal = new Point(200, 200); // TEMPORARY
				flocks.push(flock);
			}
		}
		
		public function removeUnit(unit:Unit):void {
			if (unit == null) {
				return;
			}
			var flock:Flock = unit.flock;
			if (unit.flock != null) {
				// remove unit from its flock
				flock.removeUnit(unit);
				if (flock.neighbors.length == 0) {
					flocks.splice(flocks.indexOf(flock), 1);
				}
			}
			if (contains(unit)) {
				removeChild(unit);
			}
			
			// make sure unit isn't in selectedUnits
			for each (var unit2:Unit in selectedUnits) {
				if (unit == unit2) {
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
			if (unit === base1) {
				dispatchEvent(new NavEvent(NavEvent.GAME_OVER_LOSE));
			} else if (unit === base2) {
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
	}
}