package units {
	
	import flash.geom.Point;
	import starling.display.Sprite;
	import units.*;
	
	public class Base extends Sprite {
		
		// default constants
		private static const DEFAULT_TOTAL_RESOURCES:int = 100; // starting resources
		private static const DEFAULT_RESOURCE_RATE:Number = 1; // resource per second
		private static const DEFAULT_HEALTH:int = 5000; // hitpoints
		private static const DEFAULT_RANGE:int = 50; // range in "units" of the defensive turret
		private static const DEFAULT_DAMAGE:int = 10; // damage per shot
		private static const DEFAULT_RATE_OF_FIRE:int = 1; // shots per second
		
		private var pos:Point;
		
		private var totalResources:int = DEFAULT_TOTAL_RESOURCES;
		private var resourceRate:Number = DEFAULT_RESOURCE_RATE;
		private var health:int = DEFAULT_HEALTH;
		private var range:int = DEFAULT_RANGE;
		private var damage:int = DEFAULT_DAMAGE;
		private var rateOfFire:int = DEFAULT_RATE_OF_FIRE;
		
		private var spawnType:int = Unit.INFANTRY; // TO BE REPLACED BY A QUEUE
		
		public Base(x:int, y:int) {
			super();
			pos = new Point(x, y);
		}
		
		public function spawn(unitType:int) {
			switch (unitType) {
				case Unit.INFANTRY:
					break;
				case Unit.RAIDER:
					break;
				case Unit.SNIPER:
					break;
				default:
					trace("Unknown unit type in base.spawn()");
			}
		}
		
		public function tick() {
			updateResources();
		}
		
		private function updateResources() {
			totalResources += resourceRate;
		}
				
	}
	
}