package units {
	
	import flash.geom.Point;
	
	public class Raider extends Unit {

		public static const UNIT_TYPE:int = Unit.RAIDER;
		public static const TEXTURE_NAME:String = "RaiderTexture";
		public static const MAX_SPEED:Number = 30;
		public static const MAX_ACCEL:Number = 2;
		public static const MAX_HEALTH:Number = 100; 
		public static const HEALTH_REGEN:Number = 5;
		public static const DAMAGE:Number = 10;
		public static const ROF:Number = 1;
		public static const ATTACK_RANGE:Number = 80;
		
		public function Raider(startPos:Point, owner:int = 1) {
			super(startPos, owner);
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
		}
		
	}
	
}