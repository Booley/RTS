package screens {
	
	import flash.display3D.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	
	public class MPMenu extends Sprite {
		
		private var backBtn:Button;
		
		public function MPMenu() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			// initialize and add buttons
			backBtn = new Button(Assets.getTexture("ButtonTexture"), "Back");
			backBtn.y = 0;
			addChild(backBtn);
			
			// register event listeners
			backBtn.addEventListener(TouchEvent.TOUCH, onBackBtnPress);
		}
		
		// handle backBtn press
		private function onBackBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(backBtn);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					dispatchEvent(new NavEvent(NavEvent.MP_MENU_BACK));
				}
			}
		}

	}
}