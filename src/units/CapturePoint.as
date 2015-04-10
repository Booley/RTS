package units 
{
	import flash.geom.Point;
	public class CapturePoint extends Unit
	{
		
		public function CapturePoint(startPos:Point, owner:int = 0, textureName:String) {
			super(startPos, owner);
			
			//this.unitType = 
			this.textureName = textureName;
			this.maxSpeed = 0;
			this.maxAccel = 0;
			this.maxHealth = 300;
			this.healthRegen = 0;
			this.damage = 0;
			this.rateOfFire = 0;
			this.attackRange = 40;
		}
		
		
		
		
	}

}