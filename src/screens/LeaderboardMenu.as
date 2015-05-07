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
		public var username:String;
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
			group.y = 390;
			group.width = Constants.SCREEN_WIDTH;

			group.dataProvider = new ListCollection([
				{ label: "Back", triggered: onBackBtnPress },
			]);
			group.height = Constants.SCREEN_HEIGHT / 5 * group.dataProvider.length;
			addChild( group );
			
			rank = new TextField(200, 400, "Loading ...", "Verdana", 12, 0xffffff, true);
			rank.hAlign = "left";
			rank.border = false;
			rank.y = 0;
			rank.x = 50;
			rank.color = 0x00ffff;
			addChild(rank);
			
			user = new TextField(200, 400, "", "Verdana", 12, 0xffffff, true);
			user.hAlign = "left";
			user.border = false;
			user.x = 95;
			user.y = 0;
			user.color = 0x00ffff;
			addChild(user);
			
			elo = new TextField(200, 400, "", "Verdana", 12, 0xffffff, true);
			elo.hAlign = "left";
			elo.border = false;
			elo.x = 210;
			elo.y = 0;
			elo.color = 0x00ffff;
			addChild(elo);
			
			leaders = new Leaders(this);
			
			line = new TextField(Constants.SCREEN_WIDTH, 100, "______________________________", "Verdana", 12, 0xffffff, true);
			line.y = 280;
			line.hAlign = "center";
			line.color = 0x00ffff;
			addChild(line);
			
		}
		
		public function update():void {
			leaders.update();
		}
		
		// touch handlers
		private function onBackBtnPress():void { dispatchEventWith(NavEvent.LEADERBOARD_MENU_BACK); }
	}
}