package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	import starling.text.TextField;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class MPMenu extends Sprite {
		
		private var messageText:TextField;
		
		public function MPMenu() {
			super();
			PlayScreen.isRanked = false;
			
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.dataProvider = new ListCollection([
				{ label: "Play Unranked Match", triggered: onPlayUnrankedBtnPress },
				{ label: "Play Ranked Match", triggered: onPlayRankedBtnPress },
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 8 * group.dataProvider.length;
			group.y = Constants.SCREEN_HEIGHT - group.height;
			addChild( group );
			
			messageText = new TextField(Constants.SCREEN_WIDTH, 200, "", "Verdana", 18, 0xffffff);
			messageText.y = Constants.SCREEN_WIDTH / 8;
			messageText.x = Constants.SCREEN_WIDTH / 2;
			messageText.alignPivot("center", "center");
			addChild(messageText);
		}
		
		// touch handlers
		private function onPlayUnrankedBtnPress():void { dispatchEventWith(NavEvent.MP_MENU_PLAY_UNRANKED); }
		private function onPlayRankedBtnPress():void { 
			if (LoginScreen.myUsername == "") {
				messageText.text = "You must login before\n playing a ranked match";
				return;
			}
			dispatchEventWith(NavEvent.MP_MENU_PLAY_RANKED); 
			
		}
		private function onBackBtnPress():void { 
			messageText.text = "";
			
			dispatchEventWith(NavEvent.MP_MENU_BACK);
		}
	}
}