package units {
	
	import flash.geom.Point;
	
	public class Sniper extends Unit {
		
		public function Sniper(startPos:Point) {
			super(startPos);
			this.unitType = Unit.SNIPER;
			this.textureName = "SniperTexture";
		}
		
		
		override public function createArt():void {
			// create art
			super.createArt();
			
			image.scaleX *= 0.15;
			image.scaleY *= 0.15; // TEMPORARY
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			addChild(image);
		}	
	}
	
}