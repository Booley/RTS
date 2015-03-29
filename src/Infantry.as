package 
{
	public class Infantry extends Unit {
		//subject to change
		var damage:int = 100;
		var cost:int = 100;
		var health:int = 1000;
		var speed:Number = 50;
		var x:int = BASE_X;
		var y:int = BASE_Y;
		var type:String = "infantry";
		var attackRange:int = 5;
		public function move(newX, newY);
		
		public function attack(gameUnit) {
			gameUnit.health -= this.damage;
		}
	}
}