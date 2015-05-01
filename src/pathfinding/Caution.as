package pathfinding {
	
	import be.dauntless.astar.basic2d.BasicTile;
	import flash.geom.Point;
	
	public class Caution extends BasicTile {
		
		public function Caution(x:int, y:int) {
			super(Tile.CAUTION, new Point(x, y), false);
		}
		
	}
	
}