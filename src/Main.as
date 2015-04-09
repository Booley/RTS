package
{
	import screens.*;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.TouchEvent;
	
	public class Main extends Sprite {
		
		private var mainMenu:MainMenu;
		
		private var spMenu:SPMenu;
		private var mpMenu:MPMenu;
		private var leaderboardMenu:LeaderboardMenu;
		private var optsMenu:OptsMenu;
		
		private var playScreen:PlayScreen;
		
		public function Main() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			// initialize all screens
			mainMenu = new MainMenu();
			addChild(mainMenu); // start at the menu screen TEMPORARILY
			
			spMenu = new SPMenu();
			mpMenu = new MPMenu();
			leaderboardMenu = new LeaderboardMenu();
			optsMenu = new OptsMenu();
			
			playScreen = new PlayScreen();
				
			// register event listeners
			addMainMenuEventListeners();
			addSPMenuEventListeners();
			addMPMenuEventListeners();
			addLeaderboardMenuEventListeners();
			addOptsMenuEventListeners();
			addPlayScreenEventListeners();
		}
		
		private function addMainMenuEventListeners():void {
			mainMenu.addEventListener(NavEvent.MAIN_MENU_SP, onSPBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_MP, onMPBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_LEADERBOARD, onLeaderboardBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_OPTS, onOptsBtnPress);
		}
		
		private function removeMainMenuEventListeners():void {
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_SP, onSPBtnPress);
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_MP, onMPBtnPress);
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_LEADERBOARD, onLeaderboardBtnPress);
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_OPTS, onOptsBtnPress);
		}
		
		private function addSPMenuEventListeners():void {
			spMenu.addEventListener(NavEvent.SP_MENU_BACK, onSPBackBtnPress);
			spMenu.addEventListener(NavEvent.SP_MENU_PLAY, onSPPlayBtnPress);
		}
		
		private function removeSPMenuEventListeners():void {
			spMenu.removeEventListener(NavEvent.SP_MENU_BACK, onSPBackBtnPress);
			spMenu.removeEventListener(NavEvent.SP_MENU_PLAY, onSPPlayBtnPress);
		}
		
		private function addMPMenuEventListeners():void {
			mpMenu.addEventListener(NavEvent.MP_MENU_BACK, onMPBackBtnPress);
		}
		
		private function removeMPMenuEventListeners():void {
			mpMenu.removeEventListener(NavEvent.MP_MENU_BACK, onMPBackBtnPress);
		}
		
		private function addLeaderboardMenuEventListeners():void {
			leaderboardMenu.addEventListener(NavEvent.LEADERBOARD_MENU_BACK, onLeaderboardBackBtnPress);
		}
		
		private function removeLeaderboardMenuEventListeners():void {
			leaderboardMenu.removeEventListener(NavEvent.LEADERBOARD_MENU_BACK, onLeaderboardBackBtnPress);
		}
		
		private function addOptsMenuEventListeners():void {
			optsMenu.addEventListener(NavEvent.OPTS_MENU_BACK, onOptsBackBtnPress);
		}
		
		private function removeOptsMenuEventListeners():void {
			optsMenu.removeEventListener(NavEvent.OPTS_MENU_BACK, onOptsBackBtnPress);
		}
		
		private function addPlayScreenEventListeners():void {
			playScreen.addEventListener(NavEvent.PLAY_SCREEN_BACK, onPlayScreenBackBtnPress);
			playScreen.addEventListener(NavEvent.GAME_QUIT, onGameQuit);
		}
		
		private function removePlayScreenEventListeners():void {
			playScreen.removeEventListener(NavEvent.PLAY_SCREEN_BACK, onPlayScreenBackBtnPress);
			playScreen.removeEventListener(NavEvent.GAME_QUIT, onGameQuit);
		}
		
		// handle spMenu button press
		private function onSPBtnPress(e:Event):void {
			removeChild(mainMenu);
			addChild(spMenu);
		}
		
		// handle mpMenu button press
		private function onMPBtnPress(e:Event):void {
			removeChild(mainMenu);
			addChild(mpMenu);
		}
		
		// handle leaderboardMenu button press
		private function onLeaderboardBtnPress(e:Event):void {
			removeChild(mainMenu);
			addChild(leaderboardMenu);
		}
		
		// handle optsMenu button press
		private function onOptsBtnPress(e:Event):void {
			removeChild(mainMenu);
			addChild(optsMenu);
		}
		
		// handle SPMenu's back button press
		private function onSPBackBtnPress(e:Event):void {
			removeChild(spMenu);
			addChild(mainMenu);
		}
				
		// handle SPMenu's play button press
		private function onSPPlayBtnPress(e:Event):void {
			removeChild(spMenu);
			addChild(playScreen);
		}
		
		// handle MPMenu's back button press
		private function onMPBackBtnPress(e:Event):void {
			removeChild(mpMenu);
			addChild(mainMenu);
		}
		
		// handle LeaderboardMenu's back button press
		private function onLeaderboardBackBtnPress(e:Event):void {
			removeChild(leaderboardMenu);
			addChild(mainMenu);
		}
		
		// handle OptsMenu's back button press
		private function onOptsBackBtnPress(e:Event):void {
			removeChild(optsMenu);
			addChild(mainMenu);
		}
		
		// handle OptsMenu's back button press
		private function onPlayScreenBackBtnPress(e:Event):void {
			removeChild(playScreen);
			addChild(mainMenu);
		}
		
		// handle OptsMenu's back button press
		private function onGameQuit(e:Event):void {
			removeChild(playScreen);
			addChild(mainMenu);
		}
		
	}
	
}