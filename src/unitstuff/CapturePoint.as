package unitstuff 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.display.Sprite;
	import Assets;
	
	public class CapturePoint extends Unit
	{
		public static const UNIT_TYPE:int = Unit.TURRET;
		public static const TEXTURE_NAME:String = "NeutralCaptureTexture";
		public static const MAX_SPEED:Number = 0.0;
		public static const MAX_ACCEL:Number = 0.0;
		public static const MAX_HEALTH:Number = 50; 
		public static const HEALTH_REGEN:Number = 1;
		public static const DAMAGE:Number = 50;
		public static const ROF:Number = 10;
		public static const ATTACK_RANGE:Number = 30;
		
		public function CapturePoint(startPos:Point, owner:int = 1) {
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
		
		override public function createArt(rotation:Number = 0):void {
			image = new Image(Assets.getTexture(textureName));
			image.scaleX *= 0.2;
			image.scaleY *= 0.2; // TEMPORARY
			image.alignPivot();
			addChild(image);
			
			highlightImage = new Image(Assets.getTexture(highlightTextureName));
			highlightImage.scaleX *= 0.3;
			highlightImage.scaleY *= 0.3; // TEMPORARY
			highlightImage.alignPivot();
			addChild(highlightImage);
			highlightImage.visible = false;
			
			healthBackground = new Quad(30, 6, 0x000000);
			healthBackground.x = -healthBackground.width / 2;
			healthBackground.y = -10 - healthBackground.height / 2;
			healthBackground.alpha = 0.5;
			addChild(healthBackground);
			
			healthBar = new Quad(30, 4, 0x00ff00);
			healthBar.x = -healthBar.width / 2;
			healthBar.y = -10 - healthBar.height / 2;
			healthBar.alpha = 0.5;
			addChild(healthBar);
			
		}
	}

}