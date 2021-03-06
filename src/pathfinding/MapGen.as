package pathfinding {
	
	import be.dauntless.astar.basic2d.BasicTile;
	import flash.geom.Point;
	import pathfinding.Wall;
	import pathfinding.Floor;
	import starling.display.Image;
	import unitstuff.ResourcePoint;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class MapGen {
		
		// tile types, in hexadecimal color
		
		public static const WALL:uint = 0x808080;
		public static const CAUTION:uint = 0xffff00;
		public static const FLOOR:uint = 0x000000;
		public static const NEUTRAL_CAPTURE_POINT:uint = 0x4800ff;
		public static const RED_CAPTURE_POINT:uint = 0xff0000;
		public static const BLUE_CAPTURE_POINT:uint = 0x00ffff;

		// read in the correct map as a png and convert it to a vector of tiles
		public static function getMapObstacles(mapObstacles:Class, game:Game):Vector.<Vector.<Tile>> {
			var image:Bitmap = new mapObstacles() as Bitmap;
			const MAP_WIDTH:int = image.width;
			const MAP_HEIGHT:int = image.height;
			
			var resources:Vector.<ResourcePoint> = new Vector.<ResourcePoint>();
			var map:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
			for (var j:int = 0; j < MAP_HEIGHT; j++) {
				var v:Vector.<Tile> = new Vector.<Tile>();
				for (var i:int = 0; i < MAP_WIDTH; i++) {
					var tileType:int = Tile.FLOOR;
					var color:uint = image.bitmapData.getPixel(i, j);
					if (color == WALL) {
						tileType = Tile.WALL;
					} else if (color == CAUTION) {
						tileType = Tile.CAUTION;
					} else if (color == FLOOR) {
						tileType = Tile.FLOOR;
					} else if (color == NEUTRAL_CAPTURE_POINT) {
						tileType = Tile.CAUTION;
					} else if (color == RED_CAPTURE_POINT) {
						tileType = Tile.CAUTION;
					} else if (color == BLUE_CAPTURE_POINT) {
						tileType = Tile.CAUTION;
					} 
					v.push(new Tile(i, j, tileType, color));
				}
				map.push(v);
			}
			
			return map;
		}
		
	}
	
}