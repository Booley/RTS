package units {
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.geom.Point;
	
	import screens.PlayScreen;
	
	public class Flock {
		
		public var neighbors:Vector.<Unit>;
		public var goal:Point;
		public var owner:int; // ID of player which owns the flock

		public function Flock(owner:int = 1, units:Vector.<Unit> = null) {
			this.owner = owner;
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
