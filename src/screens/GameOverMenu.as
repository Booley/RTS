package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.display.Sprite;
	
	import unitstuff.Base;
	import unitstuff.Unit;
	
	public class GameOverMenu extends Sprite {
		
		private var text:TextField;
		
		public function GameOverMenu(won:Boolean) {
			super();
			
			trace("asdf");
			
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;
			group.dataProvider = new ListCollection([
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 5 * group.dataProvider.length;
			addChild( group );
			
			if (won) {
				text = new TextField(300, 100, "You win. You are awesome.");
				text.color = 0x00ffff;
				text.filter = new BlurFilter(0.1, 0.1, 1);
			} else {
				text = new TextField(100, 100, "You suck. ");
				text.color = 0x00ffff;
				text.filter = new BlurFilter(0.1, 0.1, 1);
			}
			text.y = 100;
			addChild(text);
		}
		
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.GAME_QUIT, true); }			
	}
}