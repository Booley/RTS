package units {
	
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.geom.Point;
	
	public class Flock extends Sprite {
		
		public var neighbors:Vector.<Unit>;
		public var goal:Point;

		public function Flock(units:Vector.<Unit> = null) {
			if (units == null) {
				this.neighbors = new Vector.<Unit>();
			} else {
				this.neighbors = units;
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);

		}
		
		public function onAddToStage(e:Event):void {
			for each (var unit:Unit in neighbors) {
				this.addChild(unit);
			}
		}
			
		public function addUnit(unit:Unit):void {
			neighbors.push(unit);
			this.addChild(unit);
		}
		
		public function removeUnit(unit:Unit):void {
			this.removeChild(unit);
			neighbors.splice(neighbors.indexOf(unit),1); // uhh.... does this work?
		}
		
		public function tick(dt:Number):void {
			for each (var unit:Unit in neighbors) {
				unit.tick(dt, neighbors, goal);
			}
		}
		
	}
	
}
