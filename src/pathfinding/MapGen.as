package pathfinding {
	
	import be.dauntless.astar.basic2d.BasicTile;
	import pathfinding.Wall;
	import pathfinding.Floor;

	public class MapGen {
		
		// a map with a horizontal line in the center
		public static function map1():Vector.<Vector.<Tile>> {
			const MAP_WIDTH:int = 15;
			const MAP_HEIGHT:int = Math.floor(MAP_WIDTH * (Constants.SCREEN_HEIGHT as Number) / Constants.SCREEN_WIDTH);
			
			var map:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
			for (var i:int = 0; i < MAP_WIDTH; i++) {
				var v:Vector.<Tile> = new Vector.<Tile>();
				for (var j:int = 0; j < MAP_HEIGHT; j++) {
					v.push(new Tile(i, j, Tile.FLOOR));
				}
				map.push(v);
			}
			
			// create two walls in center
			j = Math.floor(MAP_HEIGHT / 2);
			for (i = MAP_WIDTH / 3; i < MAP_HEIGHT * 2 / 3; i++) {
				map[i][j] = new Tile(i, j, Tile.WALL); 
			}
			
			return map;
		}
		
	}
	
}