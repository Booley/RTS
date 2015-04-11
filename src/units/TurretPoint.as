package units 
{
	/**
	 * ...
	 * @author bo
	 */
	import flash.geom.Point;
	public class TurretPoint extends CapturePoint
	{
		public static const UNIT_TYPE:int = Unit.TURRET;
		public static const TEXTURE_NAME:String = "NeutralCaptureTexture";
		public static const MAX_SPEED:Number = 0.0;
		public static const MAX_ACCEL:Number = 0.0;
		public static const MAX_HEALTH:Number = 50; 
		public static const HEALTH_REGEN:Number = 1;
		public static const DAMAGE:Number = 100;
		public static const ROF:Number = 1; //rate of fire per second
		public static const ATTACK_RANGE:Number = 150;
		
		public function TurretPoint(startPos:Point, owner:int = 1) 
		{
			super(startPos, owner);
			this.unitType = Unit.TURRET;
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