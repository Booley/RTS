package screens {
	
	import flash.display3D.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Button;
	import starling.textures.ConcreteTexture;
	
	public class MainMenu extends Sprite {

		private var bg:Image;
		
		private var mainMenuPlayBtn:Button;
		private var mainMenuAboutBtn:Button;
		
		public function MainMenu() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(event:Event):void {
			mainMenuPlayBtn = new Button(Assets.getTexture("ButtonTexture"), "Play");
			addChild(mainMenuPlayBtn);
			
			mainMenuAboutBtn = new Button(Assets.getTexture("ButtonTexture"), "About");
			mainMenuAboutBtn.y = 100;
			addChild(mainMenuAboutBtn);
		}
	}
}