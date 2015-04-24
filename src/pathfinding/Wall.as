package pathfinding {
	
	import be.dauntless.astar.basic2d.BasicTile;
	import flash.geom.Point;
	
	public class Wall extends BasicTile {
		
		public function Wall(x:int, y:int) {
			super(1, new Point(x, y), false);
		}
		
	}
	
}