package unitstuff {
	/*
	 * Models all "units" in game: infantry, sniper, raider.
	 */
	import flash.geom.Point;
	import pathfinding.Tile;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.display.BlendMode;
	
	import screens.PlayScreen;
	
	public class Unit extends Sprite {
		
		// unit types
		public static const BASE:int = 0;
		public static const INFANTRY:int = 1;
		public static const RAIDER:int = 2;
		public static const SNIPER:int = 3;
		public static const RESOURCE_POINT:int = 4;
		public static const TURRET:int = 5;
		public static const OBSTACLE:int = 6;
		
		// global movement constants
		public static const DAMPENING:Number = 0.9; // dampening time constant to help smooth movement.  applied to vel each tick
		public static const ROTATION_DAMPENING:Number = 0.1; // time constant for rotation adjustment based on velocity direction
		public static const GOAL_DISTANCE_CUTOFF:Number = 35; // distance from goal before unit chooses the next goal in the pathfinding path
		public static const COST:Number = 100;
		
		// constants to override
		public static var DEFAULT_MAX_SPEED:Number = 20; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_MAX_ACCEL:Number = 1; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_MAX_HEALTH:Number = 200; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_HEALTH_REGEN:Number = 2; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_DAMAGE:Number = 10; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_ROF:Number = 2; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_ATTACK_RANGE:Number = 100; // REPLACE THIS WHEN CREATING SUBCLASSES
		public static var DEFAULT_BUILD_TIME:Number = 2; // REPLACE THIS WHEN CREATING SUBCLASSES
		
		private static var COLOR_HEALTH_NORMAL:uint = 0x00ff00;
		private static var COLOR_HEALTH_WARNING:uint = 0xffff00;
		private static var COLOR_HEALTH_CRITICAL:uint = 0xff0000;
		private static var COLOR_HEALTH_WARNING_CUTOFF:Number = 0.66;
		private static var COLOR_HEALTH_CRITICAL_CUTOFF:Number = 0.33;
		
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
		public var buildTime:Number = DEFAULT_ATTACK_RANGE;
		public var firstPlayerLastHit:Boolean;
		public var secondPlayerLastHit:Boolean;
		
		public var pos:Point;
		public var vel:Point;
		public var flock:Flock;
		public var target:Unit;
		public var owner:int; // ID of player which owns the unit
		public var goal:Point;
		public var goals:Vector.<Point>;
		public var cost:Number;
		
		// image variables
		public var image:Image;
		public var initialImageRotation:Number;
		public var highlightImage:Image;
		public var healthBackground:Quad;
		public var healthBar:Quad;

		//id
		public static var counter:int;
		public var id:int;

		// given unit type constant, return the corresponding class
		public static function getClass(type:int):Class {
			switch (type) {
				case INFANTRY:
					return Infantry;
					break;
				case RAIDER:
					return Raider;
					break;
				case SNIPER:
					return Sniper;
					break;
				default:
					return null;
			}
		}

		// a constructor for a unit
		public function Unit(startPos:Point, owner:int = 1, rotation:Number = 0) {
			this.firstPlayerLastHit = false;
			this.secondPlayerLastHit = false;
			this.id = counter + owner;		
			counter += 4;
			this.pos = startPos.clone();
			this.x = pos.x;
			this.y = pos.y;
			this.vel = new Point();
			this.owner = owner;
			this.initialImageRotation = rotation;
			this.goals = new Vector.<Point>();
			
			this.touchable = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		
		public function onAddToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			createArt();
			//createDeathArt();
			//createShootingAnimation();
		}
		
		// Idk about this method.. might remove it
		public function createArt(rotation:Number = 0):void {
			image = new Image(Assets.getAtlas().getTexture(textureName + owner));
			image.scaleX *= 0.2;
			image.scaleY *= 0.2; // TEMPORARY
			image.alignPivot();
			image.rotation = initialImageRotation;
			addChild(image);
			
			highlightImage = new Image(Assets.getAtlas().getTexture(Assets.HighlightTexture));
			highlightImage.scaleX *= 0.3;
			highlightImage.scaleY *= 0.3; // TEMPORARY
			highlightImage.alignPivot();
			highlightImage.visible = false;
			addChild(highlightImage);
			
			healthBackground = new Image(Assets.getAtlas().getTexture(Assets.HealthBackgroundTexture));
			healthBackground.x = -healthBackground.width / 2;
			healthBackground.y = -10 - healthBackground.height / 2;
			healthBackground.width = 20;
			healthBackground.height = 5;
			addChild(healthBackground);
			
			healthBar = new Image(Assets.getAtlas().getTexture(Assets.HealthBarTexture));
			healthBar.x = -healthBar.width / 2;
			healthBar.y = -10 - healthBar.height / 2;
			healthBar.width = 20;
			healthBar.height = 3;
			healthBar.color = getHealthBarColor(health, maxHealth);
			addChild(healthBar);
		}	
		
		public function highlight():void {
			highlightImage.visible = true;
		}
		
		public function unHighlight():void {
			highlightImage.visible = false;
		}
		
		public function takeDamage(dmg:Number, owner:int):void {
			this.health -= dmg;
			if (this.unitType == Unit.RESOURCE_POINT && this.health < 0) {
				this.health = 0;
				this.owner = owner;
				ResourcePoint(this).updateImage();
				PlayScreen.game.multiplayer.sendResourceCapture(ResourcePoint(this));
			}
		}
		
		public function shoot():void {
			//create a bullet object
			var bullet:Bullet = new Bullet(this.pos, target, this.damage, 0, owner); //need to change bullet type
			
			//add to list of bullets
			PlayScreen.game.addBullet(bullet); //how to access PlayScreen?
		}
		
		public function tick(dt:Number, neighbors:Vector.<Unit> = null):void {
			updateHealth(dt);
			findTarget(); // if necessary
			attackTarget(dt);
			// only move mobile units
			if (!(this.unitType == Unit.BASE || this.unitType == Unit.RESOURCE_POINT || this.unitType == Unit.TURRET)) { 
				updateGoal(dt);
				updateMovement(dt, neighbors);
			}
		}
		
		//////////////////////////////////////// Private functions ///////////////////////////////////////////
		
		private function updateHealth(dt:Number):void {
			health += healthRegen * dt;
			health = Math.min(health, maxHealth);
			healthBar.width = healthBackground.width * health / maxHealth;
			healthBar.color = getHealthBarColor(health, maxHealth);
			if (this.health <= 0) {
				if (this.unitType != RESOURCE_POINT) {
					PlayScreen.game.removeUnit(this);
					PlayScreen.game.multiplayer.sendUnitDestroy(this.id);
				}
			}
		}
		
		private function getHealthBarColor(health:int, maxHealth:int):uint {
			if (health / maxHealth < COLOR_HEALTH_CRITICAL_CUTOFF) {
				return COLOR_HEALTH_CRITICAL;
			} else if (health / maxHealth < COLOR_HEALTH_WARNING_CUTOFF) {
				return COLOR_HEALTH_WARNING;
			} else {
				return COLOR_HEALTH_NORMAL;
			}
		}
		
		
		// attempt to find a target if one doesn't exist
		// make sure target is within attack range
		private function findTarget():void {
			// make sure target is within attack range
			if (target && target.pos.subtract(pos).length > attackRange) {
				target = null;
			}
			// make sure target has not changed alliances
			if (target && target.owner == this.owner) {
				target = null;
			}
			// make sure target is not removed from screen
			if (target && target.parent == null) {
				target = null;
			}
			// target can become null in previous if statement
			if (target == null) {
				pickTarget(PlayScreen.game.getEnemyUnitIDs(this.owner));
			}
		}
		
		// prioritize closest target
		private function pickTarget(unitIDs:Vector.<int>):void {
			var bestDist:int = attackRange;
			var closestTarget:Unit;
			var unit:Unit;
			var thisDist:int;
			for each (var unitID:int in unitIDs) {
				unit = PlayScreen.game.dictionary[unitID];
				thisDist = Math.abs(unit.pos.x - this.pos.x) + Math.abs(unit.pos.y - this.pos.y);
				if (thisDist < bestDist) {
					bestDist = thisDist;
					closestTarget = unit;
				}
			}
			
			if (closestTarget) {
				target = closestTarget;
			}
			unit = null;
			closestTarget = null;
		}
		
		// update attack cooldown and shoot
		private function attackTarget(dt:Number):void {
			attackCooldown -= dt;
			if (target != null) {
				if (attackCooldown < 0) {
					if (canReachTarget(target)) {
						attackCooldown = rateOfFire;
						shoot();
						PlayScreen.game.multiplayer.sendUnitShoot(this, this.target);
					} else {
						target = null;
					}
				}
			}
		}
		
		// raycast to target to see if it is reachable
		private function canReachTarget(target:Unit):Boolean {
			var p:Point = this.pos.clone();
			var NUM_TESTS:int = 40;
			var update:Point = target.pos.subtract(this.pos);
			update.normalize(update.length / NUM_TESTS);
			for (var i:int = 0; i < NUM_TESTS; i++) {
				p.setTo(p.x + update.x, p.y + update.y);
				var indexPoint:Point = PlayScreen.game.posToIndex(p);
				var mapData:Vector.<Vector.<Tile>> = PlayScreen.game.mapData;
				if (indexPoint.x >= 0 && indexPoint.x < mapData[0].length && indexPoint.y >= 0 && indexPoint.y < mapData.length) {
					if (mapData[indexPoint.y][indexPoint.x].basicTile.getCost() == Tile.WALL) {
						return false;
					}
				}
			}
			return true;
		}
		
		private function updateGoal(dt:Number):void {
			if (goal) {
				// check whether it has reached the goal
				var dx:Number = this.x - goal.x;
				var dy:Number = this.y - goal.y;
				var distance:Number = Math.sqrt(dx * dx + dy * dy);
				// it has reached the goal
				if (distance < GOAL_DISTANCE_CUTOFF) {
					// attempt to get the next goal
					if (goals.length > 0) {
						goal = goals.pop();
					} 
				}
				
				// check whether it is too far from the goal.  probably stuck on an obstacle.
				
			} else {
				if (goals.length > 0) {
					goal = goals.pop();
				}
			}
		}
		
		private function updateMovement(dt:Number, neighbors:Vector.<Unit> = null):void {
			//update acceleration
			var otherFlockUnits:Vector.<Unit> = PlayScreen.game.getOtherFlockUnits(this);
			var accel:Point = Flocking.getAcceleration(this, neighbors, otherFlockUnits, PlayScreen.game.obstaclePoints);
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
			
			// update position
			var v:Point = vel.clone();
			v.normalize(v.length * dt);
			pos = pos.add(v);
			
			// update image position
			this.x = pos.x;
			this.y = pos.y;
			
			//update image rotation
			image.rotation %= 2 * Math.PI;
			// face target
			if (target) {
				var diff:Point = target.pos.subtract(this.pos);
				dir = Math.atan2(diff.y, diff.x);
				if (Math.abs(dir - image.rotation) > Math.PI) {
					if (dir < image.rotation) dir += 2*Math.PI;
					else dir -= 2*Math.PI;
				}
				image.rotation += (dir - image.rotation) * ROTATION_DAMPENING;
			} 
			// otherwise, face movement direction
			else {
				var dir:Number = Math.atan2(vel.y, vel.x);
				if (Math.abs(dir - image.rotation) > Math.PI) {
					if (dir < image.rotation) dir += 2*Math.PI;
					else dir -= 2*Math.PI;
				}
				image.rotation += (dir - image.rotation) * ROTATION_DAMPENING 
									* vel.length / maxSpeed; // rotation speed proportional to movement speed
			}
			
		}
		
	}
	
}