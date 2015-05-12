package unitstuff {
	
	import flash.geom.Point;
	
	import screens.PlayScreen;
	
	public class Flock {
		private static var counter:int = 0;
		
		public var units:Vector.<Unit>;
		public var id:String;
		private var avgPos:Point;
		
		public function Flock(units:Vector.<Unit> = null) {
			//create flock id
			id = "flock-" + counter;
			counter++;
			if (units == null) {
				this.units = new Vector.<Unit>();
			} else {
				this.units = units;
				for each (var unit:Unit in units) {
					if (unit) {
						unit.flock = this;
					} else {
						units.splice(units.indexOf(unit), 1);
					}
				}
			}
			this.avgPos = new Point();
			recalculateAvgPos();
		}
		
		public function addUnit(unit:Unit):void {
			units.push(unit);
			unit.flock = this;
			recalculateAvgPos();
		}
		
		public function removeUnit(unit:Unit):void {
			unit.flock = null;
			units.splice(units.indexOf(unit), 1); // uhh.... does this work?
			recalculateAvgPos();
		}
		
		public function tick(dt:Number):void {
			for each (var unit:Unit in units) {
				unit.tick(dt, units);
			}
			recalculateAvgPos();
		}
		
		public function setGoals(newGoals:Vector.<Point>):void {
			var goals:Vector.<Point>;
			for each (var unit:Unit in this.units) {
				goals = new Vector.<Point>();
				for (var i:int = 0; i < newGoals.length; i++) {
					goals.push(PlayScreen.game.indexToPos(newGoals[i]));
				}
				unit.goals = null;
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
		
		private function recalculateAvgPos():void {
			// compute average flock position
			avgPos.setTo(0, 0);
			for each (var unit:Unit in units) {
				avgPos.setTo(avgPos.x + unit.pos.x, avgPos.y + unit.pos.y);
			}
			// divide by number of neighbors to get average position of flock
			if (units.length > 0) {
				avgPos.normalize(avgPos.length / units.length);
			}
		}
		
		public function getAvgPos():Point {
			return avgPos;
		}
		
	}
	
}
