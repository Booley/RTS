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
	
	import units.*;
	
	public class Game extends Sprite {
		
		private static const DISTANCE_TO_TAP_UNIT:Number = 50; // max distance from a unit you can tap for it to select its flock
		
		private var flocks:Vector.<Flock>;
		private var bases:Vector.<Base>;
		private var selectedUnits:Vector.<Unit>;
		private var bullets:Vector.<Bullet>;
		
		private var pause:Boolean = true;
		
		public function Game() {
			super();
			
			flocks = new Vector.<Flock>();
			bases = new Vector.<Base>();
			bullets = new Vector.<Bullet>();
			
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
			
			
			var base1:Base = new Base(new Point(320 / 2, 480 - 10));
			bases.push(base1);
			addChild(base1);
			
			var base2:Base = new Base(new Point(320 / 2, 10), 2, Math.PI);
			bases.push(base2)
			addChild(base2);
			
			// END TESTING UNIT MOVEMENT }}}}}}}}}}}}}}}}}}
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
		}
		
		// tap to select A FLOCK. Return true if a flock was selected.
		public function tap(startTap:Point, endTap:Point):void {
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
			// if no units are currently selected, select the nearest flock
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
						unitVector.push(unit);
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
			return unitVector;
		}
		
		public function spawn(unitType:int, pos:Point, owner:int):void {
			var unit:Unit;
			switch (unitType) {
				case Unit.INFANTRY:
					unit = new Infantry(pos, owner)
					break;
				case Unit.RAIDER:
					unit = new Raider(pos, owner)
					break;
				case Unit.SNIPER:
					unit = new Sniper(pos, owner)
					break;
				default:
					trace("Unknown unit type in base.spawn()");
					return;
			}
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			unitVector.push(unit);
			addChild(unit);
			var flock:Flock = new Flock(unitVector);
			flock.goal = new Point(200, 200); // TEMPORARY
			flocks.push(flock);
		}
		
		public function removeUnit(unit:Unit):void {
			if (unit == null) {
				trace("WHAT THE ACTUAL FUCK1");
				return;
			}
			var flock:Flock = unit.flock;
			if (unit.flock == null) {
				trace("WHAT THE ACTUAL FUCK");
				return;
			}
			// remove unit from its flock
			flock.removeUnit(unit);
			if (flock.neighbors.length == 0) {
				flocks.splice(flocks.indexOf(flock), 1);
			}
			removeChild(unit);
			
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