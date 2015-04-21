package units {
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.geom.Point;
	
	import screens.PlayScreen;
	
	public class Flock {
		private static var counter:int = 0;
		
		public var neighbors:Vector.<Unit>;
		public var goal:Point;
		public var id:String;
		
		public function Flock(units:Vector.<Unit> = null) {
			//create flock id
			this.id = "flock-" + counter;
			counter++;
			
			if (units == null) {
				this.neighbors = new Vector.<Unit>();
			} else {
				this.neighbors = units;
				for each (var unit:Unit in units) {
					unit.flock = this;
				}
			}
		}
		
		public function addUnit(unit:Unit):void {
			neighbors.push(unit);
			unit.flock = this;
		}
		
		public function removeUnit(unit:Unit):void {
			unit.flock = null;
			neighbors.splice(neighbors.indexOf(unit),1); // uhh.... does this work?
		}
		
		public function tick(dt:Number):void {
			for each (var unit:Unit in neighbors) {
				unit.tick(dt, neighbors, goal);
			}
		}
		
	}
	
}
