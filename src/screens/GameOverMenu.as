package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.display.Image;
	
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
			
			// Gameover screen
			var winScreen:Image = new Image(Assets.getAtlas().getTexture(Assets.ButtonTexture));
			winScreen.width = Constants.SCREEN_WIDTH;
			winScreen.height = Constants.SCREEN_HEIGHT;
			winScreen.y = 2* Constants.SCREEN_HEIGHT / 5;
			//image.scaleX *= 0.5;
			winScreen.scaleY *= 0.3; // TEMPORARY
			addChild(winScreen);
			 
			// text for winning and losing.
			if (won) {
				text = new TextField(200, 100, "You win! You are awesome.", "Verdana", 20, 0x0000ff);
				text.filter = new BlurFilter(0.1, 0.1, 1);
				

			} else {
				text = new TextField(200, 100, "GameOver ", "Verdana", 22, 0x0000ff);
				text.filter = new BlurFilter(0.1, 0.1, 1);

			}
			text.x =  Constants.SCREEN_WIDTH / 2 ;
			text.alignPivot("center","center");

			text.y = 2.2 *Constants.SCREEN_HEIGHT / 4;
			addChild(text);
		}
		
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.GAME_QUIT, true); }			
	}
}