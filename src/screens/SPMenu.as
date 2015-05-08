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
			group.height = Constants.SCREEN_HEIGHT / 8 * group.dataProvider.length;
			group.y = Constants.SCREEN_HEIGHT - group.height;
			addChild(group);
			
			//will update UI
			messageText = new TextField(Constants.SCREEN_WIDTH, 25, "Difficulty: Easy", "Verdana", 18, 0xffffff);
			messageText.y = 20;
			messageText.x = Constants.SCREEN_WIDTH / 2;
			messageText.alignPivot("center", "center");
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
			diff.height = Constants.SCREEN_HEIGHT / 8;
			addChild(diff);
			
			//create options to choose from
			list = new PickerList();
			var mapList:ListCollection = new ListCollection(
				[
					{ text: map1 },
					{ text: map2 },
					{ text: map3 },
					{ text: map4 },
					{ text: map5 },
				]);
			list.dataProvider = mapList;
			list.listProperties.itemRendererFactory = function():IListItemRenderer
			 {
				 var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				 renderer.labelField = "text";
				 renderer.iconSourceField = "thumbnail";
				 renderer.defaultLabelProperties.textFormat = new TextFormat("Verdana", 30, 0xffffff);
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
			list.selectedIndex = 0;
			list.popUpContentManager = new VerticalCenteredPopUpContentManager();
			
			//handle positioning
			list.width = Constants.SCREEN_WIDTH;
			list.y = diff.y + diff.height;
			list.height = Constants.SCREEN_HEIGHT / 8;// * list.dataProvider.length;
			this.addChild(list);
		}
		
		// touch handlers
		private function onPlayBtnPress():void { 
			Game.mapSelect = list.selectedIndex + 1;
			trace(Game.mapSelect);
			dispatchEventWith(NavEvent.SP_MENU_PLAY); 
		}
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.SP_MENU_BACK); }
		private function onEasyBtnPress():void { PlayScreen.difficulty = AI.EASY; messageText.text = "Difficulty: Easy"; }
		private function onNormalBtnPress():void { PlayScreen.difficulty = AI.MEDIUM; messageText.text = "Difficulty: Normal"; }
		private function onHardBtnPress():void { PlayScreen.difficulty = AI.HARD; messageText.text = "Difficulty: Hard"; }
        
	}
}