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
			group.dataProvider = new ListCollection([
				{ label: "Register", triggered: onRegisterBtnPress },
				{ label: "Login", triggered: onLoginBtnPress },
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 8 * group.dataProvider.length;
			group.y = Constants.SCREEN_HEIGHT - group.height;
			addChild( group );
		}
		
		// touch handlers
		private function onRegisterBtnPress():void { 
			Sounds.play(Sounds.BOOP);
			dispatchEventWith(NavEvent.LOGIN_SCREEN_REGISTER); }
		private function onLoginBtnPress():void { 
			Sounds.play(Sounds.BOOP);
			dispatchEventWith(NavEvent.LOGIN_SCREEN_SUBMIT); }
		private function onBackBtnPress():void {
			Sounds.play(Sounds.BACK);
			dispatchEventWith(NavEvent.LOGIN_SCREEN_BACK); 
			}
		
		
		
	}

}