package unitstuff {
	
	import flash.geom.Point;
	
	public class Sniper extends Unit {
		
		public static const UNIT_TYPE:int = Unit.SNIPER;
		public static const TEXTURE_NAME:String = "SniperTexture";
		public static const MAX_SPEED:Number = 12;
		public static const MAX_ACCEL:Number = 0.5;
		public static const MAX_HEALTH:Number = 50; 
		public static const HEALTH_REGEN:Number = 1;
		public static const DAMAGE:Number = 50;
		public static const ROF:Number = 10;
		public static const ATTACK_RANGE:Number = 200;
		public static const BUILD_TIME:Number = 3;
		
		public function Sniper(startPos:Point, owner:int = 1, rotation:Number = 0) {
			super(startPos, owner, rotation);
			this.unitType = Unit.SNIPER;
			this.textureName = TEXTURE_NAME;
			this.maxSpeed = MAX_SPEED;
			this.maxAccel = MAX_ACCEL;
			this.maxHealth = MAX_HEALTH;
			this.health = this.maxHealth;
			this.healthRegen = HEALTH_REGEN;
			this.damage = DAMAGE;
			this.rateOfFire = ROF;
			this.attackRange = ATTACK_RANGE;
			this.buildTime = BUILD_TIME;
		}
	}
	
}