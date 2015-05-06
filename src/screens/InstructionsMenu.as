package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class InstructionsMenu extends Sprite {
		
<<<<<<< HEAD
		private var backBtn:Button;

		private var background:Image;
		
=======
>>>>>>> fe71b00771fe5497749050197ef492722b776bab
		public function InstructionsMenu() {
			super();
			
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
		}
		
		// touch handlers
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.INSTRUCTIONS_MENU_BACK); }
	}
}