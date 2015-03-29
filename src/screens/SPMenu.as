package screens {
	
	import flash.display3D.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	
	public class SPMenu extends Sprite {
		
		private var backBtn:Button;
		private var playBtn:Button;
		
		public function SPMenu() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			// initialize and add buttons
			backBtn = new Button(Assets.getTexture("ButtonTexture"), "Back");
			backBtn.y = 0;
			addChild(backBtn);
			
			playBtn = new Button(Assets.getTexture("ButtonTexture"), "Play");
			playBtn.y = 100;
			addChild(playBtn);
			
			// register event listeners
			backBtn.addEventListener(TouchEvent.TOUCH, onBackBtnPress);
			playBtn.addEventListener(TouchEvent.TOUCH, onPlayBtnPress);
		}
		
		// handle backBtn press
		private function onBackBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(backBtn);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					dispatchEvent(new NavEvent(NavEvent.SP_MENU_BACK));
				}
			}
		}
		
		// handle playBtn press
		private function onPlayBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(playBtn);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					dispatchEvent(new NavEvent(NavEvent.SP_MENU_PLAY));
				}
			}
		}

	}
}