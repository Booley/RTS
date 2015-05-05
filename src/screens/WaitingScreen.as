package screens {
	
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import starling.display.Image;
	
	public class WaitingScreen extends Sprite {
		public static var roomId:String;
		
		private var waitingRoom:WaitingRoom;
		private var backBtn:Button;
		
		public function WaitingScreen() {
			waitingRoom = new WaitingRoom(this);
			roomId = "nothing";
			super();
			
			// add background
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			backBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Back");
			backBtn.fontSize = 50;
			backBtn.width = Constants.SCREEN_WIDTH;
			backBtn.height = Constants.SCREEN_HEIGHT/5
			addChild(backBtn);
			
			var text:TextField = new TextField(300, 300, "Waiting to connect...", "Verdana", 30, 0xffffff);
			text.x = Constants.SCREEN_WIDTH / 2;
			text.y = Constants.SCREEN_HEIGHT / 2;
			addChild(text);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		public function onMatchFound(room:String):void {
			trace("Now starting game...");
			roomId = room;
			//waitingRoom.mConnection.close();
			dispatchEventWith(NavEvent.WAITING_SCREEN_CONNECT);
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
		}
		
		private function removeListeners():void {
			backBtn.removeEventListener(TouchEvent.TOUCH, onBackBtnPress);
		}
		
		// handle backBtn press
		private function onBackBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(backBtn);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					dispatchEventWith(NavEvent.WAITING_SCREEN_BACK);
				}
			}
		}
		
	}
	
}