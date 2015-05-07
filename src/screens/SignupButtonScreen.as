package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	import starling.display.Sprite;
	import starling.display.Image;
	
	public class SignupButtonScreen extends Sprite {
		
		public function SignupButtonScreen() {
			// add background
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.dataProvider = new ListCollection([
				{ label: "Submit", triggered: onSubmitBtnPress },
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 8 * group.dataProvider.length;
			group.y = Constants.SCREEN_HEIGHT - group.height;
			addChild( group );
		}
		
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.SIGNUP_SCREEN_BACK); }
		private function onSubmitBtnPress():void { dispatchEventWith(NavEvent.SIGNUP_SCREEN_SUBMIT); }
	}

}