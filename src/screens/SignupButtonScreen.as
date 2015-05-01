package screens 
{
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class SignupButtonScreen extends Sprite {
		private var backBtn:Button;
		private var submitBtn:Button;
		private var background:Image;
		
		public function SignupButtonScreen() {
			// add background
			background = new Image(Assets.getTexture("MenuBackground"));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			// initialize and add buttons
			submitBtn = new Button(Assets.getTexture("ButtonTexture"), "Register");
			submitBtn.fontSize = 50;
			submitBtn.y = 3*Constants.SCREEN_HEIGHT/5;
			submitBtn.width = Constants.SCREEN_WIDTH;
			submitBtn.height = Constants.SCREEN_HEIGHT/5
			addChild(submitBtn);
			
			backBtn = new Button(Assets.getTexture("ButtonTexture"), "Back");
			backBtn.fontSize = 50;
			backBtn.y = 4*Constants.SCREEN_HEIGHT/5;
			backBtn.width = Constants.SCREEN_WIDTH;
			backBtn.height = Constants.SCREEN_HEIGHT/5
			addChild(backBtn);
			
			
			
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
			backBtn.addEventListener(TouchEvent.TOUCH, onBackBtnPress);
			submitBtn.addEventListener(TouchEvent.TOUCH, onSubmitBtnPress);
		}
		
		private function removeListeners():void {
			backBtn.removeEventListener(TouchEvent.TOUCH, onBackBtnPress);
			submitBtn.removeEventListener(TouchEvent.TOUCH, onSubmitBtnPress);
		}
		
		private function onBackBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(backBtn);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					dispatchEvent(new NavEvent(NavEvent.SIGNUP_SCREEN_BACK));
				}
			}
		}
		
		private function onSubmitBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(submitBtn);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					dispatchEvent(new NavEvent(NavEvent.SIGNUP_SCREEN_SUBMIT));
				}
			}
		}
	}

}