package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class MPMenu extends Sprite {
		
		public function MPMenu() {
			super();
			
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.dataProvider = new ListCollection([
				{ label: "Play", triggered: onPlayBtnPress },
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 5 * group.dataProvider.length;
			addChild( group );
		}
		
		// touch handlers
		private function onPlayBtnPress():void { dispatchEventWith(NavEvent.MP_MENU_PLAY); }
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.MP_MENU_BACK); }
	}
}