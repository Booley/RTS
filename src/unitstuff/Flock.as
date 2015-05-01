package unitstuff {
	
	import be.dauntless.astar.core.Astar;
	import be.dauntless.astar.core.PathRequest;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.geom.Point;
	
	import screens.PlayScreen;
	
	public class Flock {
		private static var counter:int = 0;
		
		public var units:Vector.<Unit>;
		public var id:String;
		
		public function Flock(units:Vector.<Unit> = null) {
			//create flock id
			this.id = "flock-" + counter;
			counter++;
			
			if (units == null) {
				this.units = new Vector.<Unit>();
			} else {
				this.units = units;
				for each (var unit:Unit in units) {
					unit.flock = this;
				}
			}
		}
		
		public function addUnit(unit:Unit):void {
			units.push(unit);
			unit.flock = this;
		}
		
		public function removeUnit(unit:Unit):void {
			unit.flock = null;
			units.splice(units.indexOf(unit),1); // uhh.... does this work?
		}
		
		public function tick(dt:Number):void {
			for each (var unit:Unit in units) {
				unit.tick(dt, units);
			}
		}
		
		public function setGoals(newGoals:Vector.<Point>):void {
			for each (var unit:Unit in this.units) {
				var goals:Vector.<Point> = new Vector.<Point>();
				for (var i:int = 0; i < newGoals.length; i++) {
					goals.push(newGoals[i].clone());
				}
				unit.goals = goals;
				// don't require first few goals in the path to smooth transition
				if (unit.goals.length > 1) {
					unit.goals.pop();
				}
				if (unit.goals.length > 1) {
					unit.goals.pop();
				}
				unit.goal = null;
			}
		}	
		
		public function getAvgPos():Point {
			// compute average flock position
			var avgPos:Point = new Point();
			for each (var unit:Unit in units) {
				avgPos = avgPos.add(unit.pos);
			}
			// divide by number of neighbors to get average position of flock
			avgPos.normalize(avgPos.length / units.length);
			return avgPos;
		}
		
	}
	
}
