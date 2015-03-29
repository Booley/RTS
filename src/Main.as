package
{
	import screens.MainMenu;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.TouchEvent;
	
	public class Main extends Sprite {
		
		private var mainMenu:MainMenu;
		
		public function Main() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			mainMenu = new MainMenu();
			addChild(mainMenu);
		}
		
	}
	
}