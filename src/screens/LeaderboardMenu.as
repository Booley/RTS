package screens {
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class LeaderboardMenu extends Sprite {
		
		public var rank:TextField;
		public var user:TextField;
		public var elo:TextField;
		public static var username:String;
		public var line:TextField;
		private var leaders:Leaders;
		
		public function LeaderboardMenu() {
			super();
			
			username = "";
			
			var background:Image = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			var group:ButtonGroup = new ButtonGroup();
			group.width = Constants.SCREEN_WIDTH;

			group.dataProvider = new ListCollection([
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 8 * group.dataProvider.length;
			group.y = Constants.SCREEN_HEIGHT - group.height;
			addChild( group );
			
			rank = new TextField(Constants.SCREEN_WIDTH/4, 400, "Loading ...", "Verdana", 12, 0xffffff, true);
			rank.hAlign = "left";
			rank.y = 0;
			rank.x = Constants.SCREEN_WIDTH / 10;
			addChild(rank);
			
			user = new TextField(Constants.SCREEN_WIDTH/2, 400, "", "Verdana", 12, 0xffffff, true);
			user.hAlign = "left";
			user.x = Constants.SCREEN_WIDTH / 4;
			user.y = 0;
			addChild(user);
			
			elo = new TextField(Constants.SCREEN_WIDTH/4, 400, "", "Verdana", 12, 0xffffff, true);
			elo.hAlign = "left";
			elo.x = 3*Constants.SCREEN_WIDTH / 4;
			elo.y = 0;
			addChild(elo);
			
			leaders = new Leaders(this);
			
			line = new TextField(Constants.SCREEN_WIDTH, 100, "______________________________", "Verdana", 12, 0xffffff, true);
			line.y = 280;
			line.hAlign = "center";
			addChild(line);
			
		}
		
		public function update():void {
			leaders.update();
		}
		
		// touch handlers
		private function onBackBtnPress():void { 
			Sounds.play(Sounds.BACK);
			dispatchEventWith(NavEvent.LEADERBOARD_MENU_BACK); }
	}
}