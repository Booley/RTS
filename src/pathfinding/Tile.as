package pathfinding {
	
	import be.dauntless.astar.basic2d.BasicTile;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Tile {
		
		// step cost of each tile type
		public static const WALL:int = 1000;
		public static const FLOOR:int = 1;
		public static const CAUTION:int = 3;
		
		public var basicTile:BasicTile;
		public var type:uint;
		
		public function Tile(x:int, y:int, tileType:int, type:uint) {
			var theTileClass:Class = getClass(tileType);
			basicTile = new theTileClass(x, y);
			this.type = type;
		}

		public function getClass(tileType:int):Class {
			switch(tileType) {
				case WALL:
					return Wall;
					break;
				case FLOOR:
					return Floor;
					break;
				case CAUTION:
					return Caution;
					break;
				default:
					return null;
			}
			
		}
		
	}
	
}