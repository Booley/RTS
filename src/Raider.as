package 
{
	public class Raider implements Unit {
		//subject to change
		var damage:int = 50;
		var health:int = 800;
		var speed:Number = 100;
		var x:int = BASE_X;
		var y:int = BASE_Y;
		var type:String = "infantry";
		var attackRange:int = 10;
		public function move(newX, newY);
		
		public function attack(gameUnit) {
			gameUnit.health -= this.damage;
		}
	}
}