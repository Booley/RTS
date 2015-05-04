package unitstuff {
	
	import flash.geom.Point;
	import starling.display.Image;
	
	public class ResourcePoint extends Unit {

		public static const UNIT_TYPE:int = Unit.RESOURCE_POINT;
		public static const TEXTURE_NAME:String = "ResourcePointTexture";
		public static const MAX_SPEED:Number = 0; 
		public static const MAX_ACCEL:Number = 0;
		public static const MAX_HEALTH:Number = 100; 
		public static const HEALTH_REGEN:Number = 2;
		public static const DAMAGE:Number = 5;
		public static const ROF:Number = .3;
		public static const ATTACK_RANGE:Number = 100;
		public static const BUILD_TIME:Number = 0;
		public static const COST:Number = 1000;
		
		public static const RESOURCE_RATE:Number = 0.01;
		
		public function ResourcePoint(startPos:Point, owner:int = 3, rotation:Number = 0) {
			super(startPos, owner, rotation);
			this.cost = COST;
			this.unitType = Unit.RESOURCE_POINT;
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
		
		override public function createArt(rotation:Number = 0):void {
			super.createArt(rotation);
			image.scaleX *= 0.75;
			image.scaleY *= 0.75;
		}
		
		public function updateImage():void {
			if (image && contains(image)) removeChild(image);
			image = new Image(Assets.getTexture(textureName + owner));
			image.scaleX *= 0.15;
			image.scaleY *= 0.15; // TEMPORARY
			image.alignPivot();
			addChildAt(image, 0);
		}
		
	}
	
}