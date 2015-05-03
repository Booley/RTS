package unitstuff {
	
	import flash.geom.Point;
	import pathfinding.Tile;

	public class Flocking {
		
		// flocking behavior constants
		private static const FRIENDLY_REPULSION_WEIGHT:Number = 10000; // repulsion from neighbors
		private static const ENEMY_REPULSION_WEIGHT:Number = 120000; // repulsion from enemies
		private static const OBSTACLE_REPULSION_WEIGHT:Number = 10000000000; // repulsion from obstacles
		private static const ATTRACTION_WEIGHT:Number = 0.1; // attraction from neighbors 
		private static const MATCH_VELOCITY_WEIGHT:Number = 0.05; // want to match neighbors' velocity
		private static const GOAL_WEIGHT:Number = 0.1; // attraction to goal 
		private static const THRUST_FACTOR:Number = 10; // overall scale factor for thrust strength
		private static const MAP_BOUNDARY_REPULSION_WEIGHT:Number = 0.1;
		
		// get the net acceleration from a unit's neighbors on the unit for flocking behavior
		public static function getAcceleration(u:Unit, neighbors:Vector.<Unit>, enemies:Vector.<Unit>, obstacles:Vector.<Point>):Point {
			var accel:Point = new Point();
		
			var repulsionVector:Point = getRepulsion(u, neighbors);
			repulsionVector.normalize(repulsionVector.length * FRIENDLY_REPULSION_WEIGHT);
			accel.setTo(accel.x + repulsionVector.x, accel.y + repulsionVector.y);
		
			var enemyRepulsionVector:Point = getEnemyRepulsion(u, enemies);
			enemyRepulsionVector.normalize(enemyRepulsionVector.length * ENEMY_REPULSION_WEIGHT);
			accel.setTo(accel.x + enemyRepulsionVector.x, accel.y + enemyRepulsionVector.y);
			
			var attractionVector:Point = getAttraction(u, neighbors);
			attractionVector.normalize(attractionVector.length*ATTRACTION_WEIGHT);
			accel.setTo(accel.x + attractionVector.x, accel.y + attractionVector.y);
			
			var matchingVector:Point = matchVelocity(u, neighbors);
			matchingVector.normalize(matchingVector.length*MATCH_VELOCITY_WEIGHT);
			accel.setTo(accel.x + matchingVector.x, accel.y + matchingVector.y);
			
			var obstacleRepulsionVector:Point = getObstacleRepulsion(u, obstacles);
			obstacleRepulsionVector.normalize(obstacleRepulsionVector.length*OBSTACLE_REPULSION_WEIGHT);
			accel.setTo(accel.x + obstacleRepulsionVector.x, accel.y + obstacleRepulsionVector.y);
			
			if (u.goal != null) {
				var goalVector:Point = getGoalAttraction(u, neighbors);
				goalVector.normalize(goalVector.length*GOAL_WEIGHT);
				accel.setTo(accel.x + goalVector.x, accel.y + goalVector.y);
			} else {
				// NOT ACTUALLY USED EVER
				// make up for lack of goal weight for correct unit spacing
				attractionVector.normalize(attractionVector.length * 50);
				accel.setTo(accel.x + attractionVector.x, accel.y + attractionVector.y);
			}
			
			accel.normalize(accel.length * THRUST_FACTOR);
			
			return accel;
		}
		
		// get thrust from repulsive forces from neighbors
		private static function getRepulsion(u:Unit, neighbors:Vector.<Unit>):Point {
			var sum:Point = new Point();
			var dif:Point = new Point();
			for (var i:int = 0, l:int = neighbors.length; i < l; ++i) {
				dif.setTo(u.pos.x - neighbors[i].pos.x, u.pos.y - neighbors[i].pos.y);
				if (dif.length == 0 || dif.length > 50) continue;
				dif.normalize(1 / dif.length / dif.length);
				sum.setTo(sum.x + dif.x, sum.y + dif.y);
			}
			return sum;
		}
		
		// get thrust from repulsive forces from neighbors
		private static function getEnemyRepulsion(u:Unit, enemyUnits:Vector.<Unit>):Point {
			var sum:Point = new Point();
			var dif:Point = new Point();
			for (var i:int = 0, l:int = enemyUnits.length; i < l; ++i) {
				dif.setTo(u.pos.x - enemyUnits[i].pos.x, u.pos.y - enemyUnits[i].pos.y);
				if (dif.length == 0 || dif.length > 40) continue;
				dif.normalize(1 / dif.length / dif.length / dif.length);
				sum.setTo(sum.x + dif.x, sum.y + dif.y);
			}
			return sum;
		}
		
		// get thrust from repulsive forces from neighbors and map boundary
		private static function getObstacleRepulsion(u:Unit, obstacles:Vector.<Point>):Point {
			var sum:Point = new Point();
			var dif:Point = new Point();
			for (var i:int=0, l:int=obstacles.length; i<l; ++i) {
				dif.setTo(u.pos.x - obstacles[i].x, u.pos.y - obstacles[i].y);
				if (dif.length == 0 || dif.length > 30) continue;
				dif.normalize(1 / Math.pow(dif.length, 6));
				sum.setTo(sum.x + dif.x, sum.y + dif.y);
			}
			if (u.pos.y < 30) {
				dif.setTo(0, u.pos.y);
				if (dif.length != 0) {
					dif.normalize(MAP_BOUNDARY_REPULSION_WEIGHT / Math.pow(dif.length, 6));
					sum.setTo(sum.x + dif.x, sum.y + dif.y);
				}
			}
			if (u.pos.x < 30) {
				dif.setTo(u.pos.x, 0);
				if (dif.length != 0) {
					dif.normalize(MAP_BOUNDARY_REPULSION_WEIGHT / Math.pow(dif.length, 6));
					sum.setTo(sum.x + dif.x, sum.y + dif.y);
				}
			}
			if (u.pos.y > Constants.SCREEN_HEIGHT - 30) {
				dif.setTo(0, u.pos.y - Constants.SCREEN_HEIGHT);
				if (dif.length != 0) {
					dif.normalize(MAP_BOUNDARY_REPULSION_WEIGHT / Math.pow(dif.length, 6));
					sum.setTo(sum.x + dif.x, sum.y + dif.y);
				}
			}
			if (u.pos.x > Constants.SCREEN_WIDTH - 30) {
				dif.setTo(u.pos.x - Constants.SCREEN_WIDTH, 0);
				if (dif.length != 0) {
					dif.normalize(MAP_BOUNDARY_REPULSION_WEIGHT / Math.pow(dif.length, 6));
					sum.setTo(sum.x + dif.x, sum.y + dif.y);
				}
			}
			return sum;
		}
		
		// sum attractive forces from neighbors 
		// boids move towards center of the entire group
		private static function getAttraction(u:Unit, neighbors:Vector.<Unit>):Point {
			if (u.flock) {
				return u.flock.getAvgPos().subtract(u.pos);
			} else {
				return new Point();
			}
		}
		
		// boids should match the average velocity of their neighbors
		// return a normalized difference between the unit's velocity and the avgVel
		private static function matchVelocity(u:Unit, neighbors:Vector.<Unit>):Point {
			var sum:Point = new Point();
			for (var i:int = 0, l:int = neighbors.length; i < l; ++i) { 
				sum.setTo(sum.x + neighbors[i].vel.x - u.vel.x, sum.y + neighbors[i].vel.y - u.vel.y);
			}
			// should probably normalize by number of neighbors so larger flocks don't "pull" harder than small flocks
			sum.normalize(sum.length/neighbors.length);
			return sum;
		}
		
		// attractive force towards the goal, normalized, relative to avgPos of the entire group
		private static function getGoalAttraction(u:Unit, neighbors:Vector.<Unit>):Point {
			var accel:Point = u.goal.subtract(u.pos);
			accel.normalize(accel.length * accel.length);
			return accel;
		}
			
	}
	
}