package ai {
	
	import pathfinding.Tile;
	import unitstuff.Base;
	import unitstuff.Flock;
	import unitstuff.ResourcePoint;
	import unitstuff.Sniper;
	import unitstuff.Unit;
	import screens.PlayScreen;
	
	public class AI {
		
		// get the AI's unit movement order
		public static function getUnitMovementCommand(owner:int, flocks:Vector.<Flock>, mapData:Vector.<Vector.<Tile>>, resourcePoints:Vector.<ResourcePoint>, friendlyBase:Base, enemyBase:Base):void {
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.units) {
					if (unit.owner == owner) {
						// unit-specific preferences?
						if (unit.unitType == Unit.SNIPER) {
							// stop moving when it gets into range
							if (unit.target != null) {
								unit.goal = null;
								continue;
							}
						}
						// if near a raider, break for it  NOTE DOES NOT USE PATHFINDING.  CAN GET STUCK ON WALLS
						if (unit.unitType == Unit.INFANTRY) {
							var closestRaider:Unit = closestEnemy(unit, Unit.RAIDER, flocks);
							if (closestRaider && closestRaider.pos.subtract(unit.pos).length < closestRaider.attackRange) {
								unit.goal = closestRaider.pos;
								unit.target = closestRaider;
								continue;
							}
							
						}
						// if near a sniper, break for it  NOTE DOES NOT USE PATHFINDING.  CAN GET STUCK ON WALLS
						if (unit.unitType == Unit.RAIDER) {
							var closestSniper:Unit = closestEnemy(unit, Unit.SNIPER, flocks);
							if (closestSniper && closestSniper.pos.subtract(unit.pos).length < closestSniper.attackRange) {
								unit.goal = closestSniper.pos;
								unit.target = closestSniper;
								continue;
							}
						}
						// if no special cases have been seen, attack the nearest resource point. 
						var closestRP:ResourcePoint = closestEnemyResourcePoint(unit, resourcePoints);
						if (closestRP) {
							//PlayScreen.game.getGoals(unit.flock, closestRP.pos);
							unit.goal = closestRP.pos;
							continue;
						}
						// otherwise, charge towards the enemy's base.
						//PlayScreen.game.getGoals(unit.flock, enemyBase.pos);
						unit.goal = enemyBase.pos;
						continue;
						
					} 
				}
			}
		}
		
		private static function closestEnemy(unit1:Unit, unitType:int, flocks:Vector.<Flock>):Unit {
			var bestDist:Number = int.MAX_VALUE;
			var closestTarget:Unit;
			var thisDist:int;
			var unit:Unit;
			for (var i:int = 0, l:int = flocks.length; i < l; ++i) {
				for (var j:int = 0, l2:int = flocks[j].units.length; j < l2; ++j) {
					unit = flocks[i].units[j];
					if (unit.owner != unit1.owner) {
						if (unit.unitType == unitType) {
							thisDist = Math.abs(unit.pos.x - unit1.pos.x) + Math.abs(unit.pos.y - unit1.pos.y);
							if (thisDist < bestDist) {
								bestDist = thisDist;
								closestTarget = unit;
							}
						}
					}
				}
			}
			return closestTarget;
		}
		
		private static function closestEnemyResourcePoint(unit:Unit, resourcePoints:Vector.<ResourcePoint>):ResourcePoint {
			var bestDist:Number = int.MAX_VALUE;
			var best:ResourcePoint = null;
			for each (var rp:ResourcePoint in resourcePoints) {
				if (rp.owner != unit.owner) {
					var dist:Number = rp.pos.subtract(unit.pos).length;
					if (dist < bestDist) {
						bestDist = dist;
						best = rp;
					}
				}
			}
			return best;
		}
		
		// get the AI's build command
		public static function getUnitBuildCommand(owner:int, flocks:Vector.<Flock>, mapData:Vector.<Vector.<Tile>>):int {
			var numInfantry:Number = 0; // number of infantry the enemy has compared to the user
			var numRaiders:Number = 0;
			var numSnipers:Number = 0;
			
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.units) {
					if (unit.owner != owner) {
						if (unit.unitType == Unit.INFANTRY) numInfantry++;
						if (unit.unitType == Unit.RAIDER) numRaiders++;
						if (unit.unitType == Unit.SNIPER) numSnipers++;	
					} else {
						if (unit.unitType == Unit.INFANTRY) numRaiders -= 0.3;
						if (unit.unitType == Unit.RAIDER) numSnipers -= 0.3;
						if (unit.unitType == Unit.SNIPER) numInfantry -= 0.3;
					}
				}
			}
			//trace("i: " + numInfantry + " r: " + numRaiders + " s: " + numSnipers);
			// biggest deficit in raiders
			if (numRaiders >= numInfantry && numRaiders >= numSnipers) {
				return Unit.INFANTRY;
			}
			// biggest deficit in snipers
			if (numSnipers >= numInfantry && numSnipers >= numRaiders) {
				return Unit.RAIDER;
			}
			// biggest deficit in infantry
			if (numInfantry >= numRaiders && numInfantry >= numSnipers) {
				return Unit.SNIPER;
			}

			// default
			return Unit.INFANTRY;
			
		}
		
	}
	
}