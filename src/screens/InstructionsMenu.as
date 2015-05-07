package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class InstructionsMenu extends Sprite {
		
		public function InstructionsMenu() {
			super();
			
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			// get map background			
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.dataProvider = new ListCollection([
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 8 * group.dataProvider.length;
			addChild( group );
			
			var image:Image = new Image(Assets.getTexture2(Assets.Instructions) );
			//image.x = -30;
			image.y = group.height/1.5;
			var scale:Number = Constants.SCREEN_WIDTH / image.width;
			image.width = Constants.SCREEN_WIDTH;
			image.height *= scale;
			//image.scaleX *= 0.5;
			//image.scaleY *= 0.6; // TEMPORARY
			addChild(image);
		}
		
		// touch handlers
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.INSTRUCTIONS_MENU_BACK); }
	}
}