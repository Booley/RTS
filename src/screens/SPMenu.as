package screens {
	
	import ai.AI;
	import flash.text.TextFormat;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.popups.IPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import starling.text.TextField;
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class SPMenu extends Sprite {
		
		private static var map1:String = "Wild West";
		private static var map2:String = "Canada";
		private static var map3:String = "Ocean";
		private static var map4:String = "California";
		private static var map5:String = "Final Frontier";
		
		private var messageText:TextField;
		private var list:PickerList;
		
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
			diff.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			diff.y = messageText.y + messageText.height;
			diff.width = Constants.SCREEN_WIDTH;
			diff.dataProvider = new ListCollection([
				{ label: "Easy", triggered: onEasyBtnPress },
				{ label: "Normal", triggered: onNormalBtnPress },
				{ label: "Hard", triggered: onHardBtnPress },
			]);
			diff.height = Constants.SCREEN_HEIGHT / 18 * diff.dataProvider.length;
			addChild(diff);
			
			//create options to choose from
			list = new PickerList();
			var groceryList:ListCollection = new ListCollection(
				[
					{ text: map1, thumbnail: new Image(Assets.getTexture2(Assets.TestButton)) },
					{ text: map2, thumbnail: new Image(Assets.getTexture2(Assets.TestButton)) },
					{ text: map3, thumbnail: new Image(Assets.getTexture2(Assets.TestButton)) },
					{ text: map4, thumbnail: new Image(Assets.getTexture2(Assets.TestButton)) },
					{ text: map5, thumbnail: new Image(Assets.getTexture2(Assets.TestButton)) },
				]);
			list.dataProvider = groceryList;
			list.listProperties.itemRendererFactory = function():IListItemRenderer
			 {
				 var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				 renderer.labelField = "text";
				 renderer.iconSourceField = "thumbnail";
				 renderer.defaultLabelProperties.textFormat = new TextFormat("Verdana", 30, 0x333333);
				 return renderer;
			 };
			 
			//apply visuals
			list.listProperties.@itemRendererProperties.labelField = "text";
			list.labelField = "text";
			list.prompt = map1;
			list.listFactory = function():List
			 {
				 var popUpList:List = new List();
				 popUpList.backgroundSkin = new Image(Assets.getTexture2(Assets.TestBG) );
				
				 return popUpList;
			 };
			
			
			//apply behavior for tapping
			list.selectedIndex = -1;
			list.popUpContentManager = new VerticalCenteredPopUpContentManager();
			
			//handle positioning
			list.width = Constants.SCREEN_WIDTH;
			list.y = diff.y + diff.height;
			list.height = Constants.SCREEN_HEIGHT / 18 * list.dataProvider.length;
			this.addChild(list);
		}
		
		// touch handlers
		private function onPlayBtnPress():void { 
			PlayScreen.mapSelect = list.selectedIndex;
			dispatchEventWith(NavEvent.SP_MENU_PLAY); 
		}
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.SP_MENU_BACK); }
		private function onEasyBtnPress():void { PlayScreen.difficulty = AI.EASY; messageText.text = "Difficulty: Easy"; }
		private function onNormalBtnPress():void { PlayScreen.difficulty = AI.MEDIUM; messageText.text = "Difficulty: Normal"; }
		private function onHardBtnPress():void { PlayScreen.difficulty = AI.HARD; messageText.text = "Difficulty: Hard"; }
        
	}
}