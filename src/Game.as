package {
	
	import flash.geom.Point;
	
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
		
		private var flocks:Vector.<Flock>;
		private var bases:Vector.<Base>;
		
		private var pause:Boolean = true;
		
		public function Game() {
			super();
			
			flocks = new Vector.<Flock>();
			bases = new Vector.<Base>();
			
			// TESTING UNIT MOVEMENT AND STUFF {{{{{{{{{{{{{{{{
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for (var i:int = 0; i < 10; i++) {
				var x:Number = Math.random() * 100;
				var y:Number = Math.random() * 100 + 200;
				var unit:Unit = new Infantry(new Point(x, y));
				unitVector.push(unit);
				addChild(unit);
			}
			var flock:Flock = new Flock(unitVector);
			flocks.push(flock);
			flock.goal = new Point(200, 300);
			
			var base1:Base = new Base(new Point(320 / 2, 480 - 10));
			bases.push(base1);
			addChild(base1);
			
			var base2:Base = new Base(new Point(320 / 2, 10), Math.PI);
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
			
			for each (var flock:Flock in flocks) {
				flock.tick(dt);
			}
			
			// TEST UNIT MOVEMENT
			if (Math.random() < 0.02) {
				if (Math.random() < 0.33) {
					var unit:Unit = new Infantry(new Point(300 * Math.random(), 400 * Math.random()));
				} else if (Math.random() < 0.5) {
					var unit:Unit = new Sniper(new Point(300 * Math.random(), 400 * Math.random()));
				} else {
					var unit:Unit = new Raider(new Point(300 * Math.random(), 400 * Math.random()));
				}
				flocks[0].addUnit(unit);
				
			}
		}
		
		public function spawn(unitType:int, pos:Point):void {
			var unit:Unit;
			switch (unitType) {
				case Unit.INFANTRY:
					unit = new Infantry(pos)
					break;
				case Unit.RAIDER:
					unit = new Raider(pos)
					break;
				case Unit.SNIPER:
					unit = new Sniper(pos)
					break;
				default:
					trace("Unknown unit type in base.spawn()");
					return;
			}
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			unitVector.push(unit);
			addChild(unit);
			var flock:Flock = new Flock(unitVector);
			flock.goal = new Point(400, 200); // TEMPORARY
		}
		
		public function test(p:Point):void {
			flocks[0].goal = p;
		}

	}
}