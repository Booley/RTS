package screens {
	
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import unitstuff.Base;
	import unitstuff.Unit;
	
	public class GameOverMenu extends Sprite {
		
		private var backButton:Button;
		private var text:TextField;
		
		public function GameOverMenu(winner:int) {
			super();
			
			// initialize and add buttons
			backButton = new Button(Assets.getTexture("ButtonTexture"), "Back");
			backButton.y = 0;
			addChild(backButton);
			
			if (winner == 1) {
				text = new TextField(100, 100, "You win.");
			} else {
				text = new TextField(100, 100, "You suck.");
			}
			text.y = 100;
			addChild(text);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			addListeners();
		}
		
		public function onRemoveFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			removeListeners();
		}
		
		private function addListeners():void {
			backButton.addEventListener(TouchEvent.TOUCH, onBackButtonPress);
		}
		
		private function removeListeners():void {
			backButton.removeEventListener(TouchEvent.TOUCH, onBackButtonPress);
		}
		
		private function onBackButtonPress(e:TouchEvent):void {
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(backButton);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					dispatchEvent(new NavEvent(NavEvent.GAME_QUIT, true));
				}
			}
		}

	}
}