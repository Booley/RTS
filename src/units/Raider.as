package units {
	
	import flash.geom.Point;
	
	public class Raider extends Unit {
		
		public function Raider(startPos:Point) {
			super(startPos);
			this.unitType = Unit.RAIDER;
			this.textureName = "RaiderTexture";
		}
		
	}
	
}