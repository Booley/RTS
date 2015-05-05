package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.text.TextField;
	import starling.display.Sprite;
	import starling.display.Image;
	import flash.utils.setTimeout;
	
	public class WaitingScreen extends Sprite {
		
		public static var roomId:String;
		private var waitingRoom:WaitingRoom;
		
		public function WaitingScreen() {
			waitingRoom = new WaitingRoom(this);
			roomId = "nothing";
			super();
			
			// add background
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.dataProvider = new ListCollection([
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 5 * group.dataProvider.length;
			addChild( group );
			
			var text:TextField = new TextField(300, 300, "Waiting to connect...", "Verdana", 30, 0xffffff);
			text.x = Constants.SCREEN_WIDTH / 2;
			text.y = Constants.SCREEN_HEIGHT / 2;
			addChild(text);
		}
		
		public function onMatchFound(room:String):void {
			trace("Now starting game...");
			roomId = room;

			dispatchEventWith(NavEvent.WAITING_SCREEN_CONNECT);
			setTimeout(function():void { waitingRoom.mConnection.close() }, 0);
		}
		
		// touch handlers
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.WAITING_SCREEN_BACK); }
		
		
	}
	
}