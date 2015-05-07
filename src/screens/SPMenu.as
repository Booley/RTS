package screens {
	
	import ai.AI;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.controls.PickerList;
	import feathers.data.ListCollection;
	
	import starling.text.TextField;
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class SPMenu extends Sprite {
		
		private var messageText:TextField;
		
		public function SPMenu() {
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
			
			//will update UI
			messageText = new TextField(150, 30, "Difficulty: Easy", "Verdana", 15, 0xffffff);
			messageText.y = group.height;
			messageText.alignPivot("left", "center");
			addChild(messageText);
			
			var diff:ButtonGroup = new ButtonGroup();
			diff.y = messageText.y + messageText.height;
			diff.width = Constants.SCREEN_WIDTH;
			diff.dataProvider = new ListCollection([
				{ label: "Easy", triggered: onEasyBtnPress },
				{ label: "Normal", triggered: onNormalBtnPress },
				{ label: "Hard", triggered: onHardBtnPress },
			]);
			diff.height = Constants.SCREEN_HEIGHT / 6 * diff.dataProvider.length;
			addChild(diff);
		}
		
		// touch handlers
		private function onPlayBtnPress():void { dispatchEventWith(NavEvent.SP_MENU_PLAY); }
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.SP_MENU_BACK); }
		private function onEasyBtnPress():void { PlayScreen.difficulty = AI.EASY; messageText.text = "Difficulty: Easy"; }
		private function onNormalBtnPress():void { PlayScreen.difficulty = AI.MEDIUM; messageText.text = "Difficulty: Normal"; }
		private function onHardBtnPress():void { PlayScreen.difficulty = AI.HARD; messageText.text = "Difficulty: Hard"; }
        
	}
}