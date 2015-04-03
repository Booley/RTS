package units {
	
	import flash.geom.Point;
	
	public class Raider extends Unit {
		
		public function Raider(startPos:Point) {
			super(startPos);
			this.unitType = Unit.RAIDER;
			this.textureName = "RaiderTexture";
		}
		
		override public function createArt():void {
			// create art
			super.createArt();
			
			image.scaleX *= 0.3;
			image.scaleY *= 0.3; // TEMPORARY
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			addChild(image);
		}	
	}
	
}