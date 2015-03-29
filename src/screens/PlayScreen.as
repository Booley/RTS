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
	
	import units.Flock;
	import units.Unit;
	
	public class PlayScreen extends Sprite {
		
		private var backBtn:Button;
		
		private var flock:Flock;
		
		public function PlayScreen() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			// initialize and add buttons
			backBtn = new Button(Assets.getTexture("ButtonTexture"), "Back");
			backBtn.y = 0;
			addChild(backBtn);
			
			// register event listeners
			backBtn.addEventListener(TouchEvent.TOUCH, onBackBtnPress);
			
			
			
			
			
			// TESTING UNIT MOVEMENT AND STUFF {{{{{{{{{{{{{{{{
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			var unitVector:Vector.<Unit> = new Vector.<Unit>();
			for (var i:int = 0; i < 10; i++) {
				var x:Number = Math.random() * 100;
				var y:Number = Math.random() * 100 + 200;
				unitVector.push(new Unit(new Point(x, y)));
			}
			flock = new Flock(unitVector);
			addChild(flock);
			
			var bg:Quad = new Quad(stage.stageWidth, stage.stageHeight);
			bg.alpha = 0;
			addChildAt(bg, 0);
			// END TESTING UNIT MOVEMENT }}}}}}}}}}}}}}}}}}
			
			
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