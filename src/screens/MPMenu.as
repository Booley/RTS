package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	import starling.text.TextField;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class MPMenu extends Sprite {
		
		private var messageText:TextField;
		private var accountInfo:TextField;
		private var group:ButtonGroup;
		
		public function MPMenu() {
			super();
			PlayScreen.isRanked = false;
			
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			group = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.dataProvider = new ListCollection([
				{ label: "Play Unranked Match", triggered: onPlayUnrankedBtnPress },
				{ label: "Play Ranked Match", triggered: onPlayRankedBtnPress },
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 8 * group.dataProvider.length;
			addChild( group );
			
			messageText = new TextField(300, 200, "", "Verdana", 15, 0xffffff);
			messageText.y = 300;
			messageText.x = 0;
			addChild(messageText);
			
			accountInfo = new TextField(300, 50, "", "Verdana", 15, 0xffffff);
			accountInfo.y = group.height;
			addChild(accountInfo);
		}
		
		public function updateDisplay():void {
			
			if (LoginScreen.myUsername == "") {
				accountInfo.text = "You are not logged in yet. You may only play unranked matches.";
			}
			else {
				accountInfo.text = "You are logged in as " + LoginScreen.myUsername;
			}

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