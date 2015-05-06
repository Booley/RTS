package screens {
	//Interface for touch, also executes the tick for game.
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.ui.Multitouch;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import starling.display.Quad;
	
	import unitstuff.*;
	import ai.AI;
	
	public class PlayScreen extends Sprite {
		
		private static const TAP_LENGTH_CUTOFF:Number = 20; // length finger can travel before a tap becomes a box-select
	
		public static var game:Game;
		public static var difficulty:int = AI.EASY;
		
		private var startTap:Point;
		private var selectRect:Quad;
		private var lastTime:int;
		
		private var waitingRoom:WaitingRoom;
		public static var isMultiplayer:Boolean;
		
		// handle events and user input and pass data to the game
		// the "PlayScreen" abstraction will pass data to Game.  Game will 
		// not know whether the data comes from user input, an AI opponent,
		// or an opponent on another device.  
		public function PlayScreen(ism:Boolean) {
			super();
			
			isMultiplayer = ism;
			
			var group:ButtonGroup = new ButtonGroup();
			group.width = 20;
			group.dataProvider = new ListCollection([
				{ label: "X", triggered: onBackBtnPress },
			]);
			group.height = 20;
			addChild( group );
			
			selectRect = new Quad(1, 1, 0x00ffff);
			selectRect.alpha = 0.2;
			selectRect.visible = false;
			addChild(selectRect);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.PLAY_SCREEN_BACK); }
		
		public function newGame():void {
			game = new Game();
			if (!isMultiplayer) {
				game.start();
			}
			addChildAt(game, 0);
				
			//game.createSignalHandler();
		}
	
		public function endGame():void {
			game.end();
			removeChild(game);
			if (PlayScreen.isMultiplayer) {
				game.multiplayer.mConnection.close();
			}
		}
		
		public function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			newGame();
			
			addListeners();
		}
		
		public function onRemoveFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			endGame();
			
			removeListeners();
		}
		
		private function addListeners():void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			addEventListener(TouchEvent.TOUCH, onTouch);			
		}
		
		private function removeListeners():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function onEnterFrame(e:Event):void {
			if (game) {
				var dt:Number = Constants.FPS;
				if (lastTime) {
						dt = (getTimer() - lastTime)/1000.0;
				}
				game.tick(dt);
			}
			lastTime = getTimer();
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

	}
}