package pathfinding {
	
	import be.dauntless.astar.basic2d.BasicTile;
	import flash.geom.Point;
	
	public class Floor extends BasicTile {
		
		public function Floor(x:int, y:int) {
			super(0, new Point(x, y), true);
		}
		
	}
	
}