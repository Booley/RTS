package units {
	
	import flash.geom.Point;
	
	public class Infantry extends Unit {

		public static const UNIT_TYPE:int = Unit.INFANTRY;
		public static const TEXTURE_NAME:String = "InfantryTexture";
		public static const MAX_SPEED:Number = 50; // 15;
		public static const MAX_ACCEL:Number = 10;
		public static const MAX_HEALTH:Number = 200; 
		public static const HEALTH_REGEN:Number = 2;
		public static const DAMAGE:Number = 10;
		public static const ROF:Number = 2;
		public static const ATTACK_RANGE:Number = 100;
		
		public function Infantry(startPos:Point, owner:int = 1) {
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