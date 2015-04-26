package {
	
	import starling.events.Event;
	
	public class NavEvent extends Event {
		
		// events for the Main Menu
		public static const MAIN_MENU_SP:String = "mainMenuSP";
		public static const MAIN_MENU_MP:String = "mainMenuMP";
		public static const MAIN_MENU_LEADERBOARD:String = "mainMenuLeaderboard";
		public static const MAIN_MENU_OPTS:String = "mainMenuOpts";
		public static const MAIN_MENU_LOGIN:String = "mainMenuLogin";
		public static const MAIN_MENU_SIGNUP:String = "mainMenuSignup";
		
		// events for the Single-Player Menu
		public static const SP_MENU_BACK:String = "spMenuBack";
		public static const SP_MENU_PLAY:String = "spMenuPlay";
		
		// events for the Multi-Player Menu
		public static const MP_MENU_BACK:String = "mpMenuBack";
		public static const MP_MENU_PLAY:String = "mpMenuPlay";
		
		// events for the Leaderboard Menu
		public static const LEADERBOARD_MENU_BACK:String = "leaderboardMenuBack";
		
		// events for the Options Menu
		public static const OPTS_MENU_BACK:String = "optsMenuBack";
		
		// events for the Play Screen
		public static const PLAY_SCREEN_BACK:String = "playScreenBack";
		
		// events for the login Screen
		public static const LOGIN_SCREEN_BACK:String = "loginScreenBack";
		public static const LOGIN_SCREEN_SUBMIT:String = "loginScreenSubmit";
		
		//events for the signup screen
		public static const SIGNUP_SCREEN_BACK:String = "signupScreenBack";
		public static const SIGNUP_SCREEN_SUBMIT:String = "signupScreenSubmit";
		
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