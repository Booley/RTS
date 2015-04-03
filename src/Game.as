package {
	//Takes in commands from other classes and executes them. Also executes tick for all state-mutable objects
	
	import flash.geom.Point;
	import mx.core.ButtonAsset;
	
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
		private var bullets:Vector.<Bullet>;
		
		private var pause:Boolean = true;
		
		public function Game() {
			super();
			
			flocks = new Vector.<Flock>();
			bases = new Vector.<Base>();
			bullets = new Vector.<Bullet>();
			
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
			/*
			for each (var bullet:Bullet in bullets) {
				bullet.tick(dt);
			}
			*/
			for each (var flock:Flock in flocks) {
				flock.tick(dt);
			}
			
			// TEST UNIT MOVEMENT
			if (Math.random() < 0.02) {
				//bases[0].queueUnit(Unit.INFANTRY);
				//spawn(bases[0].nextUnit(), bases[0].pos);
				if (Math.random() < 0.33) {
					var unit:Unit = new Infantry(new Point(300 * Math.random(), 400 * Math.random()));
				} else if (Math.random() < 0.5) {
					unit = new Sniper(new Point(300 * Math.random(), 400 * Math.random()));
				} else {
					unit = new Raider(new Point(300 * Math.random(), 400 * Math.random()));
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
			flock.goal = new Point(200, 200); // TEMPORARY
			flocks.push(flock);
		}
		
		public function test(p:Point):void {
			flocks[0].goal = p;
		}
		
		public function addBullet(bullet:Bullet):void {
			bullets.push(bullet);
			addChild(bullet);
		}
		
		public function removeBullet(bullet:Bullet):void {
			//how to remove?
			/*for (var i:int = 0; i < bullets.length; i++) {
				if (bullets[i] == bullet)
					bullets.
			}
			*/
		}
	}
}