package units {
	/*
	 * Models all "units" in game: infantry, sniper, raider.
	 */
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.display.Sprite;
	
	import screens.PlayScreen;
	
	public class Unit extends Sprite {
		
		// unit types
		public static const BASE:int = 0;
		public static const INFANTRY:int = 1;
		public static const RAIDER:int = 2;
		public static const SNIPER:int = 3;
		public static const RESOURCE:int = 4;
		public static const TURRET:int = 5;
		
		// global movement constants
		public static const DAMPENING:Number = 0.95; // dampening time constant to help smooth movement.  applied to vel each tick
		public static const ROTATION_DAMPENING:Number = 0.1; // time constant for rotation adjustment based on velocity direction
		
		// constants to override
		public static var DEFAULT_MAX_SPEED:Number = 20; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_MAX_ACCEL:Number = 1; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_MAX_HEALTH:Number = 200; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_HEALTH_REGEN:Number = 2; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_DAMAGE:Number = 10; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_ROF:Number = 2; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_ATTACK_RANGE:Number = 100; // REPLACE THIS WHEN CREATING SUBCLASSES
		
		// constants which depend on unit type
		public var unitType:int;
		public var textureName:String = "default"; // fix later.  just to make compiler happy.  don't actually use the Unit() constructor
		public var maxSpeed:Number = DEFAULT_MAX_SPEED;
		public var maxAccel:Number = DEFAULT_MAX_ACCEL;
		public var maxHealth:Number = DEFAULT_MAX_HEALTH;
		public var health:Number = maxHealth;
		public var healthRegen:Number = DEFAULT_HEALTH_REGEN; // health regen per second
		public var damage:Number = DEFAULT_DAMAGE; 
		public var rateOfFire:Number = DEFAULT_ROF; // seconds per shot
		public var attackRange:int = DEFAULT_ATTACK_RANGE;
		public var attackCooldown:Number = 0;
		
		public var pos:Point;
		public var vel:Point;
		public var flock:Flock;
		public var target:Unit;
		public var owner:int; // ID of player which owns the unit
		
		// image variables
		public var image:Image;
		public var highlightImage:Image;
		public var healthBackground:Quad;
		public var healthBar:Quad;
		public var highlightTextureName:String = "HighlightTexture";

		// a constructor for a unit
		public function Unit(startPos:Point, owner:int = 1) {
			pos = startPos.clone();
			this.x = pos.x;
			this.y = pos.y;
			vel = new Point();
			this.owner = owner;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			createArt();
			//createDeathArt();
			//createShootingAnimation();
		}
		
		public function highlight():void {
			highlightImage.visible = true;
		}
		
		public function unHighlight():void {
			highlightImage.visible = false;
		}
		
		public function takeDamage(dmg:Number):void {
			this.health -= dmg;
		}
		
		public function shoot():void {
			//create a bullet object
			var bullet:Bullet = new Bullet(this.pos, target, this.damage, 0); //need to change bullet type
			
			//add to list of bullets
			PlayScreen.game.addBullet(bullet); //how to access PlayScreen?
		}
		
		// Idk about this method.. might remove it
		public function createArt():void {
			image = new Image(Assets.getTexture(textureName + owner));
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
		
		// prioritize closest target
		private function pickTarget(unitVector:Vector.<Unit>):void {
			// if no units are currently selected, select the nearest flock
			var bestDist:int = attackRange;
			var closestTarget:Unit;
			for each (var unit:Unit in unitVector) {
				var thisDist:int = unit.pos.subtract(this.pos).length;
				if (thisDist < bestDist) {
					bestDist = thisDist;
					closestTarget = unit;
				}
			}
			if (closestTarget) {
				target = closestTarget;
			}
		}
		
		// 
		public function tick(dt:Number, neighbors:Vector.<Unit> = null, goal:Point = null):void {
			health += healthRegen * dt;
			health = Math.min(health, maxHealth);
			healthBar.width = healthBackground.width * health / maxHealth;
			if (this.health <= 0) {
				PlayScreen.game.removeUnit(this);
			}
			
			
			// attempt to find a target if one doesn't exist
			if (target) {
				// make sure target is within attack range
				if (target.pos.subtract(pos).length > attackRange) {
					target = null;
				}
			}
			if (target && target.parent == null) {
				 target = null;
			}
			// target can become null in previous if statement
			if (target == null) {
				pickTarget(PlayScreen.game.getEnemyUnits(this.owner));
			}
			// attack target
			attackCooldown -= dt;
			if (target != null) {
				if (attackCooldown < 0) {
					attackCooldown = rateOfFire;
					shoot();
				}
			}
			
			if (this.unitType == Unit.BASE || this.unitType == Unit.RESOURCE || this.unitType == Unit.TURRET) return;
			
			//begin updating unit's movement {{{
			var v:Point = vel.clone();
			v.normalize(v.length * dt);
			pos = pos.add(v);
			
			this.x = pos.x;
			this.y = pos.y;
			
			//update acceleration
			var otherFlockUnits:Vector.<Unit> = PlayScreen.game.getOtherFlockUnits(this);
			var accel:Point = Flocking.getAcceleration(this, neighbors, otherFlockUnits, goal);
			accel.normalize(accel.length * dt);
			if (accel.length > maxAccel) {
				accel.normalize(maxAccel);
			}
			
			//update velocity
			vel = vel.add(accel);
			vel.normalize(vel.length * DAMPENING);
			if (vel.length > maxSpeed) {
				vel.normalize(maxSpeed);
			}
			
			// }}} end updating unit's movement
			//update rotation
			image.rotation %= 2*Math.PI;
			if (target) {
				var diff:Point = target.pos.subtract(this.pos);
				//update rotation
				dir = Math.atan2(diff.y, diff.x);
				if (Math.abs(dir - image.rotation) > Math.PI) {
					if (dir < image.rotation) dir += 2*Math.PI;
					else dir -= 2*Math.PI;
				}
				image.rotation += (dir - image.rotation) * ROTATION_DAMPENING;
			} else {
				//update rotation
				var dir:Number = Math.atan2(vel.y, vel.x);
				if (Math.abs(dir - image.rotation) > Math.PI) {
					if (dir < image.rotation) dir += 2*Math.PI;
					else dir -= 2*Math.PI;
				}
				image.rotation += (dir - image.rotation) * ROTATION_DAMPENING * vel.length / maxSpeed;
			}
			
		}
		
	}
	
}