package unitstuff {
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.geom.Point;
	
	import screens.PlayScreen;
	
	public class Flock {
		private static var counter:int = 0;
		
		public var units:Vector.<Unit>;
		public var goal:Point;
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
				unit.tick(dt, units, goal);
			}
		}
		
	}
	
}
