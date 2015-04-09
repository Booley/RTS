package screens {
	//Interface for touch, also executes the tick for game.
	
	import flash.geom.Point;
	
	import flash.ui.Multitouch;
	
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
		
		private static const TAP_LENGTH_CUTOFF:Number = 20; // length finger can travel before a tap becomes a box-select
	
		public static var game:Game;
		
		private var backBtn:Button;
		
		private var startTap:Point;
		private var selectRect:Quad;
		
		// handle events and user input and pass data to the game
		// the "PlayScreen" abstraction will pass data to Game.  Game will 
		// not know whether the data comes from user input, an AI opponent,
		// or an opponent on another device.  
		public function PlayScreen() {
			super();
			
			// initialize and add buttons
			backBtn = new Button(Assets.getTexture("ButtonTexture"), "X");
			backBtn.y = 0;
			backBtn.width = 20; 
			backBtn.height = 20;
			addChild(backBtn);
			
			// fake invisible rectangle so touch events don't fall through
			// will be removed when a background is added
			var bg:Quad = new Quad(1000, 2000);
			bg.alpha = 0;
			addChildAt(bg, 0);
			
			selectRect = new Quad(1, 1, 0x00ffff);
			selectRect.alpha = 0.2;
			selectRect.visible = false;
			addChild(selectRect);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function newGame():void {
			game = new Game();
			game.start();
			addChild(game);
		}
		
		public function endGame():void {
			game.end();
			removeChild(game);
		}
		
		public function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			// TEMPORARY.
			newGame();
			
			addListeners();
		}
		
		public function onRemoveFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			// TEMPORARY.
			endGame();
			
			removeListeners();
		}
		
		private function addListeners():void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			backBtn.addEventListener(TouchEvent.TOUCH, onBackBtnPress);
			addEventListener(TouchEvent.TOUCH, onTouch);			
		}
		
		private function removeListeners():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			backBtn.removeEventListener(TouchEvent.TOUCH, onBackBtnPress);
			removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function onEnterFrame(e:Event):void {
			if (game) {
				game.tick(Constants.FPS);
			}
		}
		
		
		// screen touches
		public function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					startTap = new Point(touch.globalX, touch.globalY);	
				} 
				else if (touch.phase == TouchPhase.MOVED) {
					if (startTap) {
						// update box-selection rectangle
						var endPos:Point = new Point(touch.globalX, touch.globalY);	
						var diff:Point = endPos.subtract(startTap);
						selectRect.visible = true;
						selectRect.x = startTap.x;
						selectRect.y = startTap.y;
						selectRect.width = diff.x;
						selectRect.height = diff.y;
					}
				} 
				else if (touch.phase == TouchPhase.ENDED) {
					if (startTap) {
						var endTap:Point = new Point(touch.globalX, touch.globalY);		
						diff = endTap.subtract(startTap);
						
						// tap
						if (diff.length < TAP_LENGTH_CUTOFF) {
							game.tap(startTap, endTap); 
						} 
						// drag
						else {
							game.drag(startTap, endTap);
						}
						
						startTap = null;
						selectRect.visible = false;
					}
				}
				
			}
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