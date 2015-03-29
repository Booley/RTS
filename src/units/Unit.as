package units {
	
	import flash.geom.Point;
	import starling.display.Image;
	import starling.events.Event;
	import starling.display.Sprite;
	
	public class Unit extends Sprite {
		
		// unit types
		public static const INFANTRY:int = 1;
		public static const RAIDER:int = 2;
		public static const SNIPER:int = 3;
		
		public static const MAX_SPEED:Number = 100; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static const MAX_ACCEL:Number = 15; // REPLACE THIS WHEN CREATING SUBCLASSES
		
		public static const DAMPENING:Number = 0.85; // dampening time constant to help smooth movement.  applied to vel each tick
		public static const ROTATION_DAMPENING:Number = 0.1; // time constant for rotation adjustment based on velocity direction
		
		public var damage:int; 
		public var rateOfFire:int;
		public var health:int;
		
		public var unitType:int;
		public var attackRange:int;
		
		public var pos:Point;
		public var vel:Point;
		public var radius:Number;
		
		public var image:Image;
		
		// a constructor for a unit
		public function Unit(startPos:Point) {
			pos = startPos.clone();
			vel = new Point();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			createArt();
			//createDeathArt();
			//createShootingAnimation();
		}
		
		// Idk about this method.. might remove it
		public function createArt():void {
			image = new Image(Assets.getTexture("InfantryTexture"));
			image.scaleX = 0.1;
			image.scaleY = 0.1;
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			addChild(image);
		}	
		
		// 
		public function tick(dt:Number, neighbors:Vector.<Unit>, goal:Point = null):void {
			var v:Point = vel.clone();
			v.normalize(v.length * dt);
			pos = pos.add(v);
			
			this.x = pos.x;
			this.y = pos.y;
			
			var accel:Point = Flocking.getAcceleration(this, neighbors, goal);
			accel.normalize(accel.length * dt);
			if (accel.length > MAX_ACCEL) {
				accel.normalize(MAX_ACCEL);
			}
			vel = vel.add(accel);
			vel.normalize(vel.length * DAMPENING);
			if (vel.length > MAX_SPEED) {
				vel.normalize(MAX_SPEED);
			}
			this.rotation %= 2*Math.PI;
			var dir:Number = Math.atan2(vel.y, vel.x);
			if (Math.abs(dir - this.rotation) > Math.PI) {
				if (dir < this.rotation) dir += 2*Math.PI;
				else dir -= 2*Math.PI;
			}
			this.rotation += (dir - this.rotation)*ROTATION_DAMPENING*vel.length/MAX_SPEED;
		}
		
	}
	
}