package screens 
{
	import starling.display.Sprite;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class SignupButtonScreen extends Sprite {
		private var backBtn:Button;
		private var submitBtn:Button;
		
		public function SignupButtonScreen() {
			backBtn = new Button(Assets.getTexture("ButtonTexture"), "Back");
			submitBtn = new Button(Assets.getTexture("ButtonTexture"), "Register");
			
			backBtn.y = 300;
			submitBtn.y = 400;
			
			addChild(backBtn);
			addChild(submitBtn);
			
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