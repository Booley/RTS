package units {
	
	import flash.geom.Point;
	
	public class Raider extends Unit {
		
		public function Raider(startPos:Point, owner:int = 1) {
			super(startPos, owner);
			this.unitType = Unit.RAIDER;
			this.textureName = "RaiderTexture";
		}
		
	}
	
}