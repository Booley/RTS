package units {
	
	import flash.geom.Point;
	
	public class Infantry extends Unit {
		
		public function Infantry(startPos:Point) {
			super(startPos);
			this.unitType = Unit.INFANTRY;
			this.textureName = "InfantryTexture";
		}
		
	}
	
}