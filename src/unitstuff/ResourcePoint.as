package unitstuff {
	
	import flash.geom.Point;
	
	public class ResourcePoint extends Unit {

		public static const UNIT_TYPE:int = Unit.RESOURCE;
		public static const TEXTURE_NAME:String = "ResourcePointTexture";
		public static const MAX_SPEED:Number = 0; 
		public static const MAX_ACCEL:Number = 0;
		public static const MAX_HEALTH:Number = 20; 
		public static const HEALTH_REGEN:Number = 2;
		public static const DAMAGE:Number = 1;
		public static const ROF:Number = .1;
		public static const ATTACK_RANGE:Number = 100;
		public static const BUILD_TIME:Number = 0;
		public static const COST:Number = 1000;
		
		public function ResourcePoint(startPos:Point, owner:int = 3, rotation:Number = 0) {
			super(startPos, owner, rotation);
			this.cost = COST;
			this.unitType = Unit.RESOURCE;
			this.textureName = TEXTURE_NAME;
			this.maxSpeed = MAX_SPEED;
			this.maxAccel = MAX_ACCEL;
			this.maxHealth = MAX_HEALTH;
			this.health = this.maxHealth;
			this.healthRegen = HEALTH_REGEN;
			this.damage = DAMAGE;
			this.rateOfFire = ROF;
			this.attackRange = ATTACK_RANGE;
			this.buildTime = 0;
		}
		
	}
	
}