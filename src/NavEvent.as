package {
	
	import starling.events.Event;
	
	public class NavEvent extends Event {
		
		// events for the Main Menu
		public static const MAIN_MENU_SP:String = "mainMenuSP";
		public static const MAIN_MENU_MP:String = "mainMenuMP";
		public static const MAIN_MENU_LEADERBOARD:String = "mainMenuLeaderboard";
		public static const MAIN_MENU_OPTS:String = "mainMenuOpts";
		
		// events for the Single-Player Menu
		public static const SP_MENU_BACK:String = "spMenuBack";
		public static const SP_MENU_PLAY:String = "spMenuPlay";
		
		// events for the Multi-Player Menu
		public static const MP_MENU_BACK:String = "mpMenuBack";
		
		// events for the Leaderboard Menu
		public static const LEADERBOARD_MENU_BACK:String = "leaderboardMenuBack";
		
		// events for the Options Menu
		public static const OPTS_MENU_BACK:String = "optsMenuBack";
		
		// events for the Play Screen
		public static const PLAY_SCREEN_BACK:String = "playScreenBack";
		
		// event for Game
		public static const GAME_OVER_WIN:String = "gameOverWin";
		public static const GAME_OVER_LOSE:String = "gameOverLose";
		public static const GAME_QUIT:String = "gameQuit";
		
		// constructor
		public function NavEvent(string:String, bubbles:Boolean = false, data:Object = null) {
			super(string, bubbles, data);
		}
	}

}