package units {
	
	import flash.geom.Point;
	
	public class Infantry extends Unit {
		
		public function Infantry(startPos:Point, owner:int = 1) {
			super(startPos, owner);
			this.unitType = Unit.INFANTRY;
			this.textureName = "InfantryTexture";
		}
		
		
		
	}
	
}