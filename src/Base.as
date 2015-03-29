package {
	public class Base {
		private var spawnType:String = "Infantry";
		private var damage:int = 100;
		private var health:int = 5000;
		private var x:int = START_X;
		private var y:int = START_Y;
		private var resourceRate:int = START_RATE;
		private var totalResources:int = INITIAL_RESOURCES;
		private var attackRange:int = 50;
		
		public set function generateResources() {
			totalResources += resourceRate;
		}
		
		public set function setSpawnType(type) {
			spawnType = type;
		}
		
		public get function spawn() {
			if (this.spawnType == "Infantry")
				return new Infantry();
			else if (this.spawnType == "RangedUnit")
				return new RangedUnit();
			else 
				return new Raider();	
		}
		
		
	}
	
}