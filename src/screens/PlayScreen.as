package screens {
	
	import flash.geom.Point;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import starling.textures.Texture;
	import starling.display.Quad;
	
	import units.*;
	
	public class PlayScreen extends Sprite {
		
		private var backBtn:Button;
		
		private var flock:Flock;
		
		public function PlayScreen() {
			super();
			
			// initialize and add buttons
			backBtn = new Button(Assets.getTexture("ButtonTexture"), "Back");
			backBtn.y = 0;
			addChild(backBtn);
			
			// fake invisible rectangle so touch events don't fall through
			// will be removed when a background is added
			var bg:Quad = new Quad(1000, 2000);
			bg.alpha = 0;
			addChildAt(bg, 0);
			
			// TESTING UNIT MOVEMENT AND STUFF {{{{{{{{{{{{{{{{
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for (var i:int = 0; i < 10; i++) {
				var x:Number = Math.random() * 100;
				var y:Number = Math.random() * 100 + 200;
				unitVector.push(new Sniper(new Point(x, y)));
			}
			flock = new Flock(unitVector);
			addChild(flock);

			// END TESTING UNIT MOVEMENT }}}}}}}}}}}}}}}}}}
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			addEventListeners();
		}
		
		public function onRemoveFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			removeEventListeners();
		}
		
		private function addEventListeners():void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			backBtn.addEventListener(TouchEvent.TOUCH, onBackBtnPress);
			addEventListener(TouchEvent.TOUCH, onTouch);			
		}
		
		private function removeEventListeners():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			backBtn.removeEventListener(TouchEvent.TOUCH, onBackBtnPress);
			removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					flock.goal = new Point(touch.globalX, touch.globalY);				
				}
			}
		}
		
		public function onEnterFrame(e:Event):void {
			flock.tick(1/30); // TESTING
		}
		
		// handle backBtn press
		private function onBackBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(backBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					dispatchEvent(new NavEvent(NavEvent.PLAY_SCREEN_BACK));
				}
			}
		}

	}
}