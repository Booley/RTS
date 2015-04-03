package units {
	
	import flash.geom.Point;

	public class Flocking {
		
		// flocking behavior constants
		public static const REPULSION_WEIGHT:Number = 500; // repulsion from neighbors
		public static const ATTRACTION_WEIGHT:Number = 1; // attraction from neighbors 
		public static const MATCH_VELOCITY_WEIGHT:Number = 0.1; // want to match neighbors' velocity
		public static const GOAL_WEIGHT:Number = 0.5; // attraction to goal 
		public static const THRUST_FACTOR:Number = 10; // overall scale factor for thrust strength
		
		
		// get the net acceleration from a unit's neighbors on the unit for flocking behavior
		public static function getAcceleration(u:Unit, neighbors:Vector.<Unit>, goal:Point = null):Point {
			// compute average flock position
			var avgPos:Point = new Point();
			for each (var unit:Unit in neighbors) {
				avgPos = avgPos.add(unit.pos);
			}
			// divide by number of neighbors to get average position of flock
			avgPos.normalize(avgPos.length/neighbors.length);
			
			var accel:Point = new Point();
			
			var repulsionVector:Point = getRepulsion(u, neighbors);
			repulsionVector.normalize(repulsionVector.length * REPULSION_WEIGHT);
			accel = accel.add(repulsionVector);
			
			var attractionVector:Point = getAttraction(u, neighbors, avgPos);
			attractionVector.normalize(attractionVector.length*ATTRACTION_WEIGHT);
			accel = accel.add(attractionVector);
			
			var matchingVector:Point = matchVelocity(u, neighbors);
			matchingVector.normalize(matchingVector.length*MATCH_VELOCITY_WEIGHT);
			accel = accel.add(matchingVector);
			
			if (goal != null) {
				var goalVector:Point = getGoalAttraction(u, neighbors, goal, avgPos);
				goalVector.normalize(goalVector.length*GOAL_WEIGHT);
				accel = accel.add(goalVector);
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
				dif.normalize(1 / dist);
				// FIX LATER: make sure to limit this so it doesn't blow up
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
		private static function getGoalAttraction(u:Unit, neighbors:Vector.<Unit>, goal:Point, avgPos:Point):Point {
			return goal.subtract(avgPos);
		}
			
	}
	
}