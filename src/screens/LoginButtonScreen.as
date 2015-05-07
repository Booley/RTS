package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.display.Sprite;
	import starling.display.Image;

	public class LoginButtonScreen extends Sprite {
		
		public function LoginButtonScreen() {
			// add background
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
		
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.y = 2 * Constants.SCREEN_HEIGHT / 5;
			group.dataProvider = new ListCollection([
				{ label: "Register", triggered: onRegisterBtnPress },
				{ label: "Login", triggered: onLoginBtnPress },
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 5 * group.dataProvider.length;
			addChild( group );
		}
		
		// touch handlers
		private function onRegisterBtnPress():void { dispatchEventWith(NavEvent.LOGIN_SCREEN_REGISTER); }
		private function onLoginBtnPress():void { dispatchEventWith(NavEvent.LOGIN_SCREEN_SUBMIT); }
		private function onBackBtnPress():void {dispatchEventWith(NavEvent.LOGIN_SCREEN_BACK); }
		
		
		
	}

}