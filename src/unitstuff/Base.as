package unitstuff {
	//Models the base where units spawn and should attack
	
	import flash.geom.Point;
	
	import screens.PlayScreen;
	
	public class Base extends Unit {
		
		// default constants
		public static const DEFAULT_TOTAL_RESOURCES:Number = 100; // starting resources
		private static const DEFAULT_RESOURCE_RATE:Number = .03; // resource per second
		
		public static const UNIT_TYPE:int = Unit.INFANTRY;
		public static const TEXTURE_NAME:String = Assets.BaseTexture;
		public static const MAX_SPEED:Number = 0;
		public static const MAX_ACCEL:Number = 0;
		public static const MAX_HEALTH:Number = 2000; 
		public static const HEALTH_REGEN:Number = 2;
		public static const DAMAGE:Number = 50;
		public static const ROF:Number = 1;
		public static const ATTACK_RANGE:Number = 120;
		
		public var totalResources:Number;
		public var resourceRate:Number;
		public var score:int;
		
		private var unitQueue:Vector.<int>;
		
		public var rallyPoint:Point;
		
		public var infiniteBuild:Boolean = false; // Should units be re-queued after creation?
		
		public var unitBuildCooldown:Number = int.MIN_VALUE;
		
		public function Base(startPos:Point, owner:int = 1, rotation:Number = 0) {
			super(startPos, owner);
			this.unitType = Unit.BASE;
			this.score = 0;
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
		
		// Idk about this method.. might remove it
		override public function createArt(rotation:Number = 0):void {
			super.createArt(rotation);
			image.scaleX *= 1.3;
			image.scaleY *= 1.3;
		}
		
		public function queueUnit(unit:int):void {
			unitQueue.push(unit);
			if (unitQueue.length == 1) {
				var nextUnitClass:Class = Unit.getClass(unit)
				if (nextUnitClass) {
					unitBuildCooldown = nextUnitClass.BUILD_TIME;
				}
			}
		}
		
		public function peekNextUnit():int {
			if (unitQueue.length > 0) {
				return unitQueue[0];
			} else {
				return -1;
			}
		}
		
		public function nextUnit():int {
			var unit:int = unitQueue.shift();
			// requeue units if infinite build is on
			if (infiniteBuild) {
				unitQueue.push(unit);
			}
			return unit;
		}
		
		public function tick2(dt:Number, resourcePoints:Vector.<ResourcePoint> = null):void {
			this.tick(dt, null);
			
			updateResources(resourcePoints, dt);
			if (unitQueue.length > 0) {
				unitBuildCooldown -= dt;
			}
			if (unitBuildCooldown < 0) {
				if (peekNextUnit() == -1) return;
				var createdUnit:Unit = PlayScreen.game.spawn(nextUnit(), this.pos, this.owner, this.rotation - Math.PI / 2);
				PlayScreen.game.multiplayer.sendUnitSpawn(createdUnit);
				
				var nextUnitClass:Class = Unit.getClass(peekNextUnit())
				if (nextUnitClass) {
					unitBuildCooldown = nextUnitClass.BUILD_TIME;
				}
			}
		}
		
		private function updateResources(resourcePoints:Vector.<ResourcePoint>, dt:Number):void {
			totalResources += resourceRate*dt*60;
			for (var i:int=0, l:int=resourcePoints.length; i<l; ++i) {
				if (resourcePoints[i].owner == this.owner) {
					totalResources += ResourcePoint.RESOURCE_RATE*dt*60;
				}
			}
		}
	
	}
	
}