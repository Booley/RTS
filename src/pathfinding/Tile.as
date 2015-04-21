package pathfinding {
	
	import be.dauntless.astar.basic2d.BasicTile;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Tile extends Sprite {
		
		public static const WALL:int = 0;
		public static const FLOOR:int = 1;
		
		public static const textureName:String = "default";
		
		public var image:Image;
		public var basicTile:BasicTile;
		
		public function Tile(x:int, y:int, tileType:int) {
			var theClass:Class = getClass(tileType);
			if (theClass) {
				basicTile = new theClass(x, y);
			}
		}
		
		// Idk about this method.. might remove it
		public function createArt(rotation:Number = 0):void {
			image = new Image(Assets.getTexture(textureName));
			//image.blendMode = BlendMode.NORMAL;
			image.scaleX *= 0.2;
			image.scaleY *= 0.2;
			image.alignPivot();
			addChild(image);
		}	

		public function getClass(tileType:int):Class {
			switch(tileType) {
				case WALL:
					return Wall;
					break;
				case FLOOR:
					return Floor;
					break;
				default:
					return null;
			}
			
		}
		
	}
	
}