package units {
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.geom.Point;
	
	import screens.PlayScreen;
	
	public class Flock {
		
		public var neighbors:Vector.<Unit>;
		public var goal:Point;

		public function Flock(units:Vector.<Unit> = null) {
			if (units == null) {
				this.neighbors = new Vector.<Unit>();
			} else {
				this.neighbors = units;
			}
		}
			
		public function addUnit(unit:Unit):void {
			neighbors.push(unit);
			PlayScreen.game.addChild(unit);
		}
		
		public function removeUnit(unit:Unit):void {
			PlayScreen.game.removeChild(unit);
			neighbors.splice(neighbors.indexOf(unit),1); // uhh.... does this work?
		}
		
		public function tick(dt:Number):void {
			// compute average flock position
			var avgPos:Point = new Point();
			for each (var unit:Unit in neighbors) {
				avgPos = avgPos.add(unit.pos);
			}
			// divide by number of neighbors to get average position of flock
			avgPos.normalize(avgPos.length/neighbors.length);
			
			for each (unit in neighbors) {
				unit.tick(dt, neighbors, avgPos, goal);
			}
		}
		
	}
	
}
