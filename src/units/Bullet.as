package units {
	
	import screens.PlayScreen;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.display.Sprite;
	
	public class Bullet extends Sprite {
		
		// bullet types
		public static const MAIN_BULLET:int = 0;
		
		public static const MAX_SPEED:Number = 100; // REPLACE THIS WHEN CREATING SUBCLASSES
		
		public var damage:int; 
		public var bulletType:int;
		
		public var pos:Point;
		public var vel:Point;
		
		public var target:Unit;
		
		public var owner:int;
		
		public var image:Image;
		public var textureName:String = "BulletTexture"; // fix later.  just to make compiler happy.  don't actually use the Unit() constructor
		
		public function Bullet(startPos:Point, target:Unit, damage:int, bulletType:int, owner:int) {
			pos = startPos.clone();
			this.x = pos.x;
			this.y = pos.y;
			vel = new Point();
			
			this.target = target;
			this.damage = damage;
			this.bulletType = bulletType;
			
			this.owner = owner;
			
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
			image.scaleX *= 0.1;
			image.scaleY *= 0.1; // TEMPORARY
			image.alignPivot();
			addChild(image);
		}
		
		// 
		public function tick(dt:Number):void {
			//begin updating bullet's movement {{{
			
			//update velocity
			vel = target.pos.subtract(pos);
			vel.normalize(MAX_SPEED);
			
			var v:Point = vel.clone();
			v.normalize(v.length * dt);
			
			// reached target
			var dist:Number = target.pos.subtract(pos).length;  // CHECK "if (target)" first before accessing target.pos
			if (dist < v.length) {
				PlayScreen.game.removeBullet(this);
				//if (target.flock != null) {
					target.takeDamage(damage);
				//}
				return;
			}
			
			pos = pos.add(v);
			this.x = pos.x;
			this.y = pos.y;
			
			//update rotation
			image.rotation %= 2*Math.PI;
			var dir:Number = Math.atan2(vel.y, vel.x);
			if (Math.abs(dir - image.rotation) > Math.PI) {
				if (dir < image.rotation) dir += 2*Math.PI;
				else dir -= 2*Math.PI;
			}
			image.rotation = dir;
			
			// }}} end updating bullet's movement
		}
		
	}
	
}