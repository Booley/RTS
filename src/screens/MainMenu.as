package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class MainMenu extends Sprite {
		
		public function MainMenu() {
			super();
			
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.dataProvider = new ListCollection([
				{ label: "Single-Player", triggered: onSPBtnPress },
				{ label: "Multi-Player", triggered: onMPBtnPress },
				{ label: "Instructions", triggered: onInstructionsBtnPress },
				{ label: "Leaderboards", triggered: onLeaderboardBtnPress },
				{ label: "Login", triggered: onLoginBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 5 * group.dataProvider.length;
			addChild( group );
		}
		
		// touch handlers
		private function onSPBtnPress():void { dispatchEventWith(NavEvent.MAIN_MENU_SP); }
		private function onMPBtnPress():void { dispatchEventWith(NavEvent.MAIN_MENU_MP); }
		private function onLeaderboardBtnPress():void { dispatchEventWith(NavEvent.MAIN_MENU_LEADERBOARD); }
		private function onInstructionsBtnPress():void { dispatchEventWith(NavEvent.MAIN_MENU_OPTS); }
		private function onLoginBtnPress():void { dispatchEventWith(NavEvent.MAIN_MENU_LOGIN); }
		private function onSignupBtnPress():void { dispatchEventWith(NavEvent.MAIN_MENU_SIGNUP); }
	}
}