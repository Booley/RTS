package units {
	
	import flash.geom.Point;
	
	public class Sniper extends Unit {
		
		public function Sniper(startPos:Point, owner:int = 1) {
			super(startPos, owner);
			this.unitType = Unit.SNIPER;
			this.textureName = "SniperTexture";
		}
	}
	
}