package {
	
	public class Base {
		
		private var spawnType:String = "Infantry";
		private var health:int = 5000;
		private var x:int = START_X;
		private var y:int = START_Y;
		private var resourceRate:int = START_RATE;
		private var totalResources:int = INITIAL_RESOURCES;
		
		private var attackRange:int = 50;  // range in "units" of the defensive turret
		private var damage:int = 100;      // damage per shot
		private var rateOfFire:int = 1;    // shots per second
		
		public set function generateResources() {
			totalResources += resourceRate;
		}
		
		public set function setSpawnType(type) {
			spawnType = type;
		}
		
		public get function spawn() {
			if (this.spawnType == "Infantry")
				return new units.Infantry();
			else if (this.spawnType == "RangedUnit")
				return new units.Sniper();
			else 
				return new units.Raider();	
		}
		
		
	}
	
}