package units {
	
	import flash.geom.Point;
	
	public class Obstacle extends Unit {

		public static const UNIT_TYPE:int = Unit.INFANTRY;
		public static const TEXTURE_NAME:String = "InfantryTexture";
		public static const MAX_SPEED:Number = 0; // 15;
		public static const MAX_ACCEL:Number = 0;
		public static const MAX_HEALTH:Number = 10000; 
		public static const HEALTH_REGEN:Number = 2;
		public static const DAMAGE:Number = 0;
		public static const ROF:Number = 2;
		public static const ATTACK_RANGE:Number = 0;
		public static const BUILD_TIME:Number = +2;
		
		public function Obstacle(startPos:Point, owner:int = 3) {
			super(startPos, owner);
			this.unitType = Unit.OBSTACLE;
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