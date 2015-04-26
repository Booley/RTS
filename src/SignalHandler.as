package 
{
	/**
	 * ...
	 * @author bo
	 */
	import flash.geom.Point;
	import screens.PlayScreen;
	import unitstuff.*;
	
	public class SignalHandler {
		
		public var game:Game;
		
		public function SignalHandler() {
			
		}
		
		public function handleUnitDestroyed(id:int):void {
			var unit:Unit = game.dictionary[id];
			if (!unit) {
				game.removeUnit(unit);
			}
		}
		
		public function handleMovement(ids:String, goal:Point):void {
			var units:Vector.<Unit> = game.idStringToUnitVector(ids);
			for each (var unit:Unit in units) {
				if (!unit) {
					throw new Error("Can't move null unit");
				}
				var oldFlock:Flock = unit.flock;
				if (oldFlock) {
					oldFlock.removeUnit(unit);
					if (oldFlock.units.length == 0) {
						game.flocks.splice(game.flocks.indexOf(oldFlock), 1);
					}
				}
			}
			var newFlock:Flock = new Flock(units);
			PlayScreen.game.getGoals(newFlock, goal);
			game.flocks.push(newFlock);
		}
	}

}