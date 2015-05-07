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
			group.height = Constants.SCREEN_HEIGHT / 8 * group.dataProvider.length;
			group.y = Constants.SCREEN_HEIGHT - group.height;
			addChild( group );
			
			var text:TextField = new TextField(Constants.SCREEN_WIDTH, 25, "Searching for game...", "Verdana", 18, 0xffffff);
			text.x = 0;
			text.y = Constants.SCREEN_HEIGHT / 4;
			addChild(text);
		}
		
		public function onMatchFound(room:String):void {
			trace("Now starting game...");
			
			roomId = room;
			dispatchEventWith(NavEvent.WAITING_SCREEN_CONNECT);
			//PlayScreen.game.start();
		}
		
		// touch handlers
		private function onBackBtnPress():void { 
			setTimeout(function():void { waitingRoom.mConnection.close() }, 0 );
			dispatchEventWith(NavEvent.WAITING_SCREEN_BACK); 
		}
	}
	
}