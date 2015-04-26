package unitstuff {
	
	import flash.geom.Point;
	import pathfinding.Tile;

	public class Flocking {
		
		// flocking behavior constants
		public static const FRIENDLY_REPULSION_WEIGHT:Number = 10000; // repulsion from neighbors
		public static const ENEMY_REPULSION_WEIGHT:Number = 80000; // repulsion from enemies
		public static const OBSTACLE_REPULSION_WEIGHT:Number = 10000000000; // repulsion from obstacles
		public static const ATTRACTION_WEIGHT:Number = 0.1; // attraction from neighbors 
		public static const MATCH_VELOCITY_WEIGHT:Number = 0.05; // want to match neighbors' velocity
		public static const GOAL_WEIGHT:Number = 0.1; // attraction to goal 
		public static const THRUST_FACTOR:Number = 10; // overall scale factor for thrust strength
		public static const MAP_BOUNDARY_REPULSION_WEIGHT:Number = 0.1;
		
		// get the net acceleration from a unit's neighbors on the unit for flocking behavior
		public static function getAcceleration(u:Unit, neighbors:Vector.<Unit>, enemies:Vector.<Unit>, obstacles:Vector.<Point>):Point {
			// compute average flock position
			var avgPos:Point = new Point();
			for each (var unit:Unit in neighbors) {
				avgPos = avgPos.add(unit.pos);
			}
			// divide by number of neighbors to get average position of flock
			avgPos.normalize(avgPos.length/neighbors.length);
			
			var accel:Point = new Point();
			
			var repulsionVector:Point = getRepulsion(u, neighbors);
			repulsionVector.normalize(repulsionVector.length * FRIENDLY_REPULSION_WEIGHT);
			accel = accel.add(repulsionVector);
			
			var enemyRepulsionVector:Point = getEnemyRepulsion(u, enemies);
			enemyRepulsionVector.normalize(enemyRepulsionVector.length * ENEMY_REPULSION_WEIGHT);
			accel = accel.add(enemyRepulsionVector);
			
			var attractionVector:Point = getAttraction(u, neighbors, avgPos);
			attractionVector.normalize(attractionVector.length*ATTRACTION_WEIGHT);
			accel = accel.add(attractionVector);
			
			var matchingVector:Point = matchVelocity(u, neighbors);
			matchingVector.normalize(matchingVector.length*MATCH_VELOCITY_WEIGHT);
			accel = accel.add(matchingVector);
			
			var obstacleRepulsionVector:Point = getObstacleRepulsion(u, obstacles);
			obstacleRepulsionVector.normalize(obstacleRepulsionVector.length*OBSTACLE_REPULSION_WEIGHT);
			accel = accel.add(obstacleRepulsionVector);
			
			if (u.goal != null) {
				var goalVector:Point = getGoalAttraction(u, neighbors);
				goalVector.normalize(goalVector.length*GOAL_WEIGHT);
				accel = accel.add(goalVector);
			} else {
				// NOT ACTUALLY USED EVER
				// make up for lack of goal weight for correct unit spacing
				attractionVector.normalize(attractionVector.length * 50);
				accel = accel.add(attractionVector);
			}
			
			accel.normalize(accel.length * THRUST_FACTOR);
			
			return accel;
		}
		
		// get thrust from repulsive forces from neighbors
		private static function getRepulsion(u:Unit, neighbors:Vector.<Unit>):Point {
			var sum:Point = new Point();
			for each (var unit:Unit in neighbors) {
				var dif:Point = u.pos.subtract(unit.pos);
				var dist:Number = dif.length;
				if (dist == 0) continue;
				dif.normalize(1 / dist / dist);
				sum = sum.add(dif);
			}
			return sum;
		}
		
		// get thrust from repulsive forces from neighbors
		private static function getEnemyRepulsion(u:Unit, neighbors:Vector.<Unit>):Point {
			var sum:Point = new Point();
			for each (var unit:Unit in neighbors) {
				var dif:Point = u.pos.subtract(unit.pos);
				var dist:Number = dif.length;
				if (dist == 0) continue;
				dif.normalize(1 / dist / dist / dist);
				sum = sum.add(dif);
			}
			return sum;
		}
		
		// get thrust from repulsive forces from neighbors and map boundary
		private static function getObstacleRepulsion(u:Unit, obstacles:Vector.<Point>):Point {
			var sum:Point = new Point();
			for each (var obstacle:Point in obstacles) {
				var dif:Point = u.pos.subtract(obstacle);
				var dist:Number = dif.length;
				if (dist == 0) continue;
				dif.normalize(1 / Math.pow(dist, 6));
				sum = sum.add(dif);
			}
			dif = u.pos.subtract(new Point(u.pos.x, 0));
			dist = dif.length;
			if (dist != 0) {
				dif.normalize(MAP_BOUNDARY_REPULSION_WEIGHT / Math.pow(dist, 6));
				sum = sum.add(dif);
			}
			
			dif = u.pos.subtract(new Point(0, u.pos.y));
			dist = dif.length;
			if (dist != 0) {
				dif.normalize(MAP_BOUNDARY_REPULSION_WEIGHT / Math.pow(dist, 6));
				sum = sum.add(dif);
			}
			
			dif = u.pos.subtract(new Point(u.pos.x, Constants.SCREEN_HEIGHT));
			dist = dif.length;
			if (dist != 0) {
				dif.normalize(MAP_BOUNDARY_REPULSION_WEIGHT / Math.pow(dist, 6));
				sum = sum.add(dif);
			}
			
			dif = u.pos.subtract(new Point(Constants.SCREEN_WIDTH, u.pos.y));
			dist = dif.length;
			if (dist != 0) {
				dif.normalize(MAP_BOUNDARY_REPULSION_WEIGHT / Math.pow(dist, 6));
				sum = sum.add(dif);
			}
			
			return sum;
		}
		
		// sum attractive forces from neighbors 
		// boids move towards center of the entire group
		private static function getAttraction(u:Unit, neighbors:Vector.<Unit>, avgPos:Point):Point {
			return avgPos.subtract(u.pos);
		}
		
		// boids should match the average velocity of their neighbors
		// return a normalized difference between the unit's velocity and the avgVel
		private static function matchVelocity(u:Unit, neighbors:Vector.<Unit>):Point {
			var sum:Point = new Point();
			for each (var unit:Unit in neighbors) {
				sum = sum.add(unit.vel.subtract(u.vel));
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