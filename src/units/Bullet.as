package units {
	import flash.geom.Point;
	import starling.display.Image;
	import starling.events.Event;
	import starling.display.Sprite;
	
	public class Bullet extends Sprite {
		
		// bullet types
		public static const MAIN_BULLET:int = 0;
		
		public static const MAX_SPEED:Number = 150; // REPLACE THIS WHEN CREATING SUBCLASSES
		
		public var damage:int; 
		
		public var bulletType:int;
		
		public var pos:Point;
		public var vel:Point;

		public var target:Unit;
		
		public var image:Image;
		
		public var textureName:String = "BulletTexture"; // fix later.  just to make compiler happy.  don't actually use the Unit() constructor
		
		public function Bullet(startPos:Point, target:Unit, damage:int, bulletType:int) {
			pos = startPos.clone();
			this.x = pos.x;
			this.y = pos.y;
			vel = new Point();
			
			this.target = target;
			this.damage = damage;
			this.bulletType = bulletType;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		
		public function onAddToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			createArt();
			//createDeathArt();
			//createShootingAnimation();
		}
		
		// Idk about this method.. might remove it
		public function createArt():void {
			image = new Image(Assets.getTexture(textureName));
			image.scaleX *= 0.3;
			image.scaleY *= 0.3; // TEMPORARY
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			addChild(image);
		}	
		
		// 
		public function tick(dt:Number):void {
			//begin updating unit's movement {{{
			var v:Point = vel.clone();
			v.normalize(v.length * dt);
			pos = pos.add(v);
			
			this.x = pos.x;
			this.y = pos.y;
			
			//update velocity
			vel = this.target.pos.subtract(pos);
			vel.normalize(MAX_SPEED);
			if (vel.length > MAX_SPEED) {
				vel.normalize(MAX_SPEED);
			}
			
			// }}} end updating unit's movement
			
			// reached target
			if (this.pos.equals(this.target.pos)) {
				// removeBullet(); ?
				this.target.takeDamage(damage);
			}
		}
		
	}
	
}