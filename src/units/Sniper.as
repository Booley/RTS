package units {
	
	import flash.geom.Point;
	
	public class Sniper extends Unit {
		
		public function Sniper(startPos:Point) {
			super(startPos);
			this.unitType = Unit.SNIPER;
			this.textureName = "SniperTexture";
		}
		
	}
	
}