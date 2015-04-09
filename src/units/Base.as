package units {
	//Models the base where units spawn and should attack
	
	import flash.geom.Point;
		
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	
	import screens.PlayScreen;
	
	public class Base extends Unit {
		
		// default constants
		private static const DEFAULT_TOTAL_RESOURCES:int = 100; // starting resources
		private static const DEFAULT_RESOURCE_RATE:Number = 1; // resource per second
		
		public static const UNIT_TYPE:int = Unit.INFANTRY;
		public static const TEXTURE_NAME:String = "BaseTexture";
		public static const MAX_SPEED:Number = 0;
		public static const MAX_ACCEL:Number = 0;
		public static const MAX_HEALTH:Number = 50; 
		public static const HEALTH_REGEN:Number = 2;
		public static const DAMAGE:Number = 50;
		public static const ROF:Number = 1;
		public static const ATTACK_RANGE:Number = 120;
		
		private static const UNIT_BUILD_COOLDOWN_RESET:Number = 3; // seconds
		
		private var totalResources:int;
		private var resourceRate:Number;
		
		private var unitQueue:Vector.<int>;
		
		public var rallyPoint:Point;
		
		public var infiniteBuild:Boolean = false; // Should units be re-queued after creation?
		
		public var unitBuildCooldown:Number = UNIT_BUILD_COOLDOWN_RESET;
		
		public function Base(startPos:Point, owner:int = 1, rotation:Number = 0) {
			super(startPos, owner);
			this.unitType = Unit.BASE;
			this.textureName = TEXTURE_NAME;
			this.maxSpeed = MAX_SPEED;
			this.maxAccel = MAX_ACCEL;
			this.maxHealth = MAX_HEALTH;
			this.health = this.maxHealth;
			this.healthRegen = HEALTH_REGEN;
			this.damage = DAMAGE;
			this.rateOfFire = ROF;
			this.attackRange = ATTACK_RANGE;
			
			this.totalResources = DEFAULT_TOTAL_RESOURCES;
			this.resourceRate = DEFAULT_RESOURCE_RATE;
			
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
		
		override public function tick(dt:Number, neighbors:Vector.<Unit> = null, goal:Point = null):void {
			super.tick(dt, neighbors, goal);
			
			updateResources();
			if (unitQueue.length > 0) {
				unitBuildCooldown -= dt;
			}
			if (unitBuildCooldown < 0) {
				unitBuildCooldown = UNIT_BUILD_COOLDOWN_RESET;
				PlayScreen.game.spawn(nextUnit(), this.pos, this.owner);
			}
		}
		
		private function updateResources():void {
			totalResources += resourceRate;
		}
				
	}
	
}