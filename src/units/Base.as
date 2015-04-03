package units {
	
	import flash.geom.Point;
		
	import starling.events.Event
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Base extends Unit {
		
		// default constants
		private static const DEFAULT_TOTAL_RESOURCES:int = 100; // starting resources
		private static const DEFAULT_RESOURCE_RATE:Number = 1; // resource per second
		private static const DEFAULT_HEALTH:int = 5000; // hitpoints
		private static const DEFAULT_RANGE:int = 50; // range in "units" of the defensive turret
		private static const DEFAULT_DAMAGE:int = 10; // damage per shot
		private static const DEFAULT_RATE_OF_FIRE:int = 1; // shots per second
		
		private var totalResources:int = DEFAULT_TOTAL_RESOURCES;
		private var resourceRate:Number = DEFAULT_RESOURCE_RATE;
		private var health:int = DEFAULT_HEALTH;
		private var range:int = DEFAULT_RANGE;
		private var damage:int = DEFAULT_DAMAGE;
		private var rateOfFire:int = DEFAULT_RATE_OF_FIRE;
		
		private var unitQueue:Vector.<int>;
		
		public var rallyPoint:Point;
		
		public var infiniteBuild:Boolean = false; // Should units be re-queued after creation?
		
		public function Base(startPos:Point, rotation:Number = 0) {
			super(startPos);
			unitType = Unit.BASE;
			textureName = "BaseTexture";
			
			this.rotation = rotation;
			rallyPoint = pos.clone();
			
			unitQueue = new Vector.<int>();
		}
		
		public function queueUnit(unit:int):void {
			unitQueue.push(unit);
		}
		
		public function nextUnit():int {
			var unit:int = unitQueue.shift();
			// requeue units if infinite build is on
			if (infiniteBuild) {
				unitQueue.push(unit);
			}
			return unit;
		}
		
		override public function tick(dt:Number, neighbors:Vector.<Unit> = null, avgPos:Point = null, goal:Point = null):void {
			updateResources();
		}
		
		private function updateResources():void {
			totalResources += resourceRate;
		}
				
	}
	
}