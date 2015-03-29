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
				
			// register event listeners
			mainMenu.addEventListener(NavEvent.MAIN_MENU_SP, onSPBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_MP, onMPBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_LEADERBOARD, onLeaderboardBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_OPTS, onOptsBtnPress);
			
			spMenu.addEventListener(NavEvent.SP_MENU_BACK, onSPBackBtnPress);
			
			mpMenu.addEventListener(NavEvent.MP_MENU_BACK, onMPBackBtnPress);
			
			leaderboardMenu.addEventListener(NavEvent.LEADERBOARD_MENU_BACK, onLeaderboardBackBtnPress);
			
			optsMenu.addEventListener(NavEvent.OPTS_MENU_BACK, onOptsBackBtnPress);
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
		
	}
	
}