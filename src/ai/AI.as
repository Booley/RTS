package ai {
	
	import flash.geom.Point;
	
	import pathfinding.Tile;
	import unitstuff.Base;
	import unitstuff.Flock;
	import unitstuff.ResourcePoint;
	import unitstuff.Sniper;
	import unitstuff.Unit;
	import screens.PlayScreen;
	
	public class AI {
		
		public static const EASY:int = 0;
		public static const MEDIUM:int = 1;
		public static const HARD:int = 2;
		
		private static const FLOCK_MERGE_DISTANCE:Number = 120; // max distance for like units to be merged into 1 flock.
		
		// get the AI's unit movement order
		public static function getUnitMovementCommand(difficulty:int, owner:int, flocks:Vector.<Flock>, mapData:Vector.<Vector.<Tile>>, resourcePoints:Vector.<ResourcePoint>, friendlyBase:Base, enemyBase:Base):void {
			var myUnits:Vector.<Unit> = new Vector.<Unit>();
			for each (var flock:Flock in flocks) {
				for each (var unit:Unit in flock.units) {
					if (unit.owner == owner) {
						myUnits.push(unit);
					}
				}
			}
			
			// merge flocks
			for each (unit in myUnits) {
				for each (var otherUnit:Unit in myUnits) {
					if (unit.id != otherUnit.id) {
						//if (unit.goal == otherUnit.goal) {
							if (unit.unitType == otherUnit.unitType) {
								if (unit.flock.getAvgPos().subtract(otherUnit.pos).length < FLOCK_MERGE_DISTANCE) {
									otherUnit.flock.removeUnit(otherUnit);
									unit.flock.addUnit(otherUnit);
								}
							}
						//}
					}
				}
			}	
				
			for each (unit in myUnits) {
				if (difficulty > MEDIUM) {
					// unit-specific preferences?
					if (unit.unitType == Unit.SNIPER) {
						// stop moving when it gets into range
						if (unit.target != null) {
							unit.goals = new Vector.<Point>();
							unit.goal = null;
							continue;
						}
					}
					// let the unit just chill if it is already attacking a resource point
					if ((unit.target != null) && unit.target.unitType == Unit.RESOURCE_POINT) {
						continue;
					}
				}
				
				// if the unit is already doing something, let it continue
				if (unit.goals.length > 0) continue;
				if (difficulty > MEDIUM) {
					if (unit.unitType == Unit.INFANTRY) {
						// follow raiders
						var closestRaider:Unit = closestEnemy(unit, Unit.RAIDER, flocks);
						if (closestRaider && closestRaider.pos.subtract(unit.pos).length < closestRaider.attackRange) {
							PlayScreen.game.getGoals(unit.flock, closestRaider.pos);
							continue;
						}
						
					}
					
					if (unit.unitType == Unit.RAIDER) {
						// rush a sniper
						var closestSniper:Unit = closestEnemy(unit, Unit.SNIPER, flocks);
						if (closestSniper && closestSniper.pos.subtract(unit.pos).length < closestSniper.attackRange) {
							PlayScreen.game.getGoals(unit.flock, closestSniper.pos);
							continue;
						}
					}
				}
				if (difficulty > EASY) {
					// if no special cases have been seen, attack the nearest resource point. 
					var closestRP:ResourcePoint = closestEnemyResourcePoint(unit, resourcePoints);
					if (closestRP != null) {
						PlayScreen.game.getGoals(unit.flock, closestRP.pos);
						continue;
					}
				}
				
				// otherwise, charge towards the enemy's base.
				if (unit.target == null) {
					PlayScreen.game.getGoals(unit.flock, enemyBase.pos);
				}
				continue;
			}
		}
		
		private static function closestEnemy(unit1:Unit, unitType:int, flocks:Vector.<Flock>):Unit {
			var bestDist:Number = int.MAX_VALUE;
			var closestTarget:Unit;
			var thisDist:int;
			var unit:Unit;
			for (var i:int = 0, l:int = flocks.length; i < l; i++) {
				for (var j:int = 0, l2:int = flocks[i].units.length; j < l2; j++) {
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
			var best:ResourcePoint;
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
		public static function getUnitBuildCommand(difficulty:int, owner:int, flocks:Vector.<Flock>, mapData:Vector.<Vector.<Tile>>, resourcePoints:Vector.<ResourcePoint>, friendlyBase:Base, enemyBase:Base):int {
			
			if (difficulty == AI.EASY) {
				if (Math.random() < 0.33) {
					return Unit.INFANTRY;
				} else if (Math.random() < 0.5) {
					return Unit.RAIDER;
				} else {
					return Unit.SNIPER;
				}
			}
			
			var enemyRPs:int = 0;
			var friendlyRPs:int = 0;
			for each (var rp:ResourcePoint in resourcePoints) {
				if (rp.owner == owner) {
					friendlyRPs++;
				} else {
					enemyRPs++;
				}
			}
			if (difficulty > AI.MEDIUM) {
				// if the bot has TOTAL map control, switch to snipers
				if (friendlyRPs > enemyRPs * 3) {
					return Unit.SNIPER;
				}
				
				// if the bot has map control, switch to infantry and snipers
				if (friendlyRPs > enemyRPs) {
					if (Math.random() > 0.5) return Unit.INFANTRY;
					else return Unit.SNIPER;
				}
			}
				
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
						if (difficulty > MEDIUM) {
							if (unit.unitType == Unit.INFANTRY) {
								numRaiders -= 0.3;
							}
							if (unit.unitType == Unit.RAIDER) {
								numSnipers -= 0.3;
							}
							if (unit.unitType == Unit.SNIPER) {
								numInfantry -= 0.3;
							}
						}
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