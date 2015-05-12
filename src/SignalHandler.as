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
		
		public function SignalHandler() {
			
		}
		
		public function handleUnitDestroyed(id:int):void {
			var unit:Unit = PlayScreen.game.dictionary[id];
			if (unit) {
				PlayScreen.game.removeUnit(unit);
			}
		}
		
		public function handleMovement(ids:String, goal:Point):void {
			var units:Vector.<Unit> = PlayScreen.game.idStringToUnitVector(ids);
			for each (var unit:Unit in units) {
				if (!unit) {
					continue;
					//throw new Error("Can't move null unit");
				}
				var oldFlock:Flock = unit.flock;
				if (oldFlock) {
					oldFlock.removeUnit(unit);
					if (oldFlock.units.length == 0) {
						PlayScreen.game.flocks.splice(PlayScreen.game.flocks.indexOf(oldFlock), 1);
					}
				}
			}
			trace(goal);
			var newFlock:Flock = new Flock(units);
			PlayScreen.game.getGoals(newFlock, goal);
			PlayScreen.game.flocks.push(newFlock);
		}
		
		public function handleSpawn(type:int, owner:int):void {
			var base:Base;
			if (owner == 1) {
				base = PlayScreen.game.base1;
			}
			else {
				base = PlayScreen.game.base2;
			}
			PlayScreen.game.spawn(type, base.pos, owner, base.rotation - Math.PI/2);
		}
		
		public function handlePositions(posString:String):void {
			trace("Syncing positions now");
			PlayScreen.game.updateUnitsFromMovementString(posString);
		}
		
		public function handleResourceCapture(id:int, owner:int):void {
			var captured:ResourcePoint = ResourcePoint(PlayScreen.game.dictionary[id]);
			if (captured) {
				captured.health = 0;
				captured.owner = owner;
				captured.updateImage();
			}
		}
	}

}