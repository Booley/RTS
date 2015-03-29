package
{
	import starling.events.Event;
	import starling.text.TextField;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.TouchEvent;
	
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			// testing output and input
			var tf:TextField = new TextField(100, 50, "HELLO WORLD");
			this.addChild(tf);
			
		}
		
	}
	
}