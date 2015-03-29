package 
{
	public interface Unit 
	{
		var damage:int;
		var health:int;
		var speed:Number;
		var x:int;
		var y:int;
		var type:String;
		var attackRange:int;
		public function move(newX, newY);
		public function attack(gameUnit);
	}	
	
}