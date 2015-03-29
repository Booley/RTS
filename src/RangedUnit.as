package 
{
	public class RangedUnit extends Unit {
		//subject to change
		var damage:int = 150;
		var health:int = 400;
		var cost:int = 100;
		var speed:Number = 50;
		var x:int = BASE_X;
		var y:int = BASE_Y;
		var type:String = "infantry";
		var attackRange:int = 100;
		public function move(newX, newY);
		
		public function attack(gameUnit) {
			gameUnit.health -= this.damage;
		}
	}
}