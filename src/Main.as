package {
	
	import screens.*;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.TouchEvent;
	import starling.core.Starling;
	
	public class Main extends Sprite {
		
		private var mainMenu:MainMenu;
		private var spMenu:SPMenu;
		private var mpMenu:MPMenu;
		private var leaderboardMenu:LeaderboardMenu;
		private var instructionsMenu:InstructionsMenu;
		private var loginScreen:LoginScreen;
		private var loginButtonScreen:LoginButtonScreen;
		private var signupScreen:SignupScreen;
		private var signupButtonScreen:SignupButtonScreen;
		private var waitingScreen:WaitingScreen;
		private var playScreen:PlayScreen;
		
		public function Main() {
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			Starling.current.root.alpha = 0.999;
			setTheme();
			
			// initialize all screens
			mainMenu = new MainMenu();
			addChild(mainMenu); // start at the menu screen TEMPORARILY
			
			spMenu = new SPMenu();
			mpMenu = new MPMenu();
			leaderboardMenu = new LeaderboardMenu();
			instructionsMenu = new InstructionsMenu();
			
			loginScreen = new LoginScreen(mainMenu);
			loginButtonScreen = new LoginButtonScreen();
			signupScreen = new SignupScreen();
			signupButtonScreen = new SignupButtonScreen();
				
			// register event listeners
			addMainMenuEventListeners();
			addSPMenuEventListeners();
			addMPMenuEventListeners();
			addLeaderboardMenuEventListeners();
			addOptsMenuEventListeners();
			addLoginScreenEventListeners();
			addSignupScreenEventListeners();
		}
		
		private function setTheme():void {
			new RTSTheme();
		}
		
		private function addMainMenuEventListeners():void {
			mainMenu.addEventListener(NavEvent.MAIN_MENU_SP, onSPBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_MP, onMPBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_LEADERBOARD, onLeaderboardBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_OPTS, onInstructionsBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_LOGIN, onLoginBtnPress);
			mainMenu.addEventListener(NavEvent.MAIN_MENU_SIGNUP, onSignupBtnPress);
		}
		
		private function removeMainMenuEventListeners():void {
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_SP, onSPBtnPress);
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_MP, onMPBtnPress);
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_LEADERBOARD, onLeaderboardBtnPress);
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_OPTS, onInstructionsBtnPress);
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_LOGIN, onLoginBtnPress);
			mainMenu.removeEventListener(NavEvent.MAIN_MENU_SIGNUP, onSignupBtnPress);
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
			mpMenu.addEventListener(NavEvent.MP_MENU_PLAY_UNRANKED, onMPPlayUnrankedBtnPress);
			mpMenu.addEventListener(NavEvent.MP_MENU_PLAY_RANKED, onMPPlayRankedBtnPress);
		}
		
		private function removeMPMenuEventListeners():void {
			mpMenu.removeEventListener(NavEvent.MP_MENU_BACK, onMPBackBtnPress);
			mpMenu.removeEventListener(NavEvent.MP_MENU_PLAY_UNRANKED, onMPPlayUnrankedBtnPress);
			mpMenu.removeEventListener(NavEvent.MP_MENU_PLAY_RANKED, onMPPlayRankedBtnPress);
		}
		
		private function addLeaderboardMenuEventListeners():void {
			leaderboardMenu.addEventListener(NavEvent.LEADERBOARD_MENU_BACK, onLeaderboardBackBtnPress);
		}
		
		private function removeLeaderboardMenuEventListeners():void {
			leaderboardMenu.removeEventListener(NavEvent.LEADERBOARD_MENU_BACK, onLeaderboardBackBtnPress);
		}
		
		private function addOptsMenuEventListeners():void {
			instructionsMenu.addEventListener(NavEvent.INSTRUCTIONS_MENU_BACK, onInstructionsBackBtnPress);
		}
		
		private function removeOptsMenuEventListeners():void {
			instructionsMenu.removeEventListener(NavEvent.INSTRUCTIONS_MENU_BACK, onInstructionsBackBtnPress);
		}
		
		private function addPlayScreenEventListeners():void {
			playScreen.addEventListener(NavEvent.PLAY_SCREEN_BACK, onPlayScreenBackBtnPress);
			playScreen.addEventListener(NavEvent.GAME_QUIT, onGameQuit);
		}
		
		private function removePlayScreenEventListeners():void {
			playScreen.removeEventListener(NavEvent.PLAY_SCREEN_BACK, onPlayScreenBackBtnPress);
			playScreen.removeEventListener(NavEvent.GAME_QUIT, onGameQuit);
		}
		
		private function addLoginScreenEventListeners():void {
			loginButtonScreen.addEventListener(NavEvent.LOGIN_SCREEN_REGISTER, onLoginScreenRegisterBtnPress);
			loginButtonScreen.addEventListener(NavEvent.LOGIN_SCREEN_BACK, onLoginScreenBackBtnPress);
			loginButtonScreen.addEventListener(NavEvent.LOGIN_SCREEN_SUBMIT, onLoginScreenSubmitBtnPress);
		}
		
		private function removeLoginScreenEventListeners():void {
			loginButtonScreen.removeEventListener(NavEvent.LOGIN_SCREEN_REGISTER, onLoginScreenRegisterBtnPress);
			loginButtonScreen.removeEventListener(NavEvent.LOGIN_SCREEN_BACK, onLoginScreenBackBtnPress);
			loginButtonScreen.removeEventListener(NavEvent.LOGIN_SCREEN_SUBMIT, onLoginScreenSubmitBtnPress);
		}
		
		private function addSignupScreenEventListeners():void {
			signupButtonScreen.addEventListener(NavEvent.SIGNUP_SCREEN_BACK, onSignupScreenBackBtnPress);
			signupButtonScreen.addEventListener(NavEvent.SIGNUP_SCREEN_SUBMIT, onSignupScreenSubmitBtnPress);
		}
		
		private function removeSignupScreenEventListeners():void {
			signupButtonScreen.removeEventListener(NavEvent.SIGNUP_SCREEN_BACK, onSignupScreenBackBtnPress);
			signupButtonScreen.removeEventListener(NavEvent.SIGNUP_SCREEN_SUBMIT, onSignupScreenSubmitBtnPress);
		}
		
		private function addWaitingScreenEventListeners():void {
			waitingScreen.addEventListener(NavEvent.WAITING_SCREEN_BACK, onWaitingScreenBackBtnPress);
			waitingScreen.addEventListener(NavEvent.WAITING_SCREEN_CONNECT, onWaitingScreenConnect);
		}
		
		private function removeWaitingScreenEventListeners():void {
			waitingScreen.removeEventListener(NavEvent.WAITING_SCREEN_BACK, onWaitingScreenBackBtnPress);
			waitingScreen.removeEventListener(NavEvent.WAITING_SCREEN_CONNECT, onWaitingScreenConnect);
		}
		
		// handle spMenu button press
		private function onSPBtnPress(e:Event):void {
			removeChild(mainMenu);
			addChild(spMenu);
		}
		
		// handle mpMenu button press
		private function onMPBtnPress(e:Event):void {
			mpMenu.updateDisplay();
			removeChild(mainMenu);
			addChild(mpMenu);
		}
		
		// handle leaderboardMenu button press
		private function onLeaderboardBtnPress(e:Event):void {
			removeChild(mainMenu);
			leaderboardMenu.update();
			addChild(leaderboardMenu);
		}
		
		// handle instructionsMenu button press
		private function onInstructionsBtnPress(e:Event):void {
			removeChild(mainMenu);
			addChild(instructionsMenu);
		}
		
		//handle loginScreen button press
		private function onLoginBtnPress(e:Event):void {
			removeChild(mainMenu);
			addChild(loginButtonScreen);
			Starling.current.nativeOverlay.addChild(loginScreen);
		}
		
		//handle signupScreen button press
		private function onSignupBtnPress(e:Event):void {
			Starling.current.nativeOverlay.removeChild(loginScreen);
			removeChild(loginButtonScreen);
			addChild(signupButtonScreen);
			Starling.current.nativeOverlay.addChild(signupScreen);
		}
		
		// handle SPMenu's back button press
		private function onSPBackBtnPress(e:Event):void {
			removeChild(spMenu);
			addChild(mainMenu);
		}	
		
		// handle SPMenu's play button press
		private function onSPPlayBtnPress(e:Event):void {
			removeChild(spMenu);
			playScreen = new PlayScreen(false);
			addPlayScreenEventListeners();
			addChild(playScreen);
		}
		
		// handle MPMenu's back button press
		private function onMPBackBtnPress(e:Event):void {
			removeChild(mpMenu);
			addChild(mainMenu);
		}
		
		// handle MPMenu's play button press
		private function onMPPlayUnrankedBtnPress(e:Event):void {
			removeChild(mpMenu);
			PlayScreen.isRanked = false;
			waitingScreen = new WaitingScreen();
			addWaitingScreenEventListeners();
			addChild(waitingScreen);
			
			//EDIT THIS TO BYPASS SCREEN
			//waitingScreen.onMatchFound();
		}
		
		// handle MPMenu's play button press
		private function onMPPlayRankedBtnPress(e:Event):void {			
			removeChild(mpMenu);
			PlayScreen.isRanked = true;
			waitingScreen = new WaitingScreen();
			addWaitingScreenEventListeners();
			addChild(waitingScreen);
			
			//EDIT THIS TO BYPASS SCREEN
			//waitingScreen.onMatchFound();
		}
		
		
		private function onWaitingScreenConnect(e:Event):void {
			removeChild(waitingScreen);
			playScreen = new PlayScreen(true);
			addPlayScreenEventListeners();
			addChild(playScreen);
		}
		
		// handle LeaderboardMenu's back button press
		private function onLeaderboardBackBtnPress(e:Event):void {
			removeChild(leaderboardMenu);
			addChild(mainMenu);
		}
		
		// handle InstructionsMenu's back button press
		private function onInstructionsBackBtnPress(e:Event):void {
			removeChild(instructionsMenu);
			addChild(mainMenu);
		}
		
		// handle PlayScreen's back button press
		private function onPlayScreenBackBtnPress(e:Event):void {
			removeChild(playScreen);
			removePlayScreenEventListeners();
			addChild(mainMenu);
		}
		
		// handle Waiting Screen's back button press
		private function onWaitingScreenBackBtnPress(e:Event):void {
			removeChild(waitingScreen);
			addChild(mainMenu);
		}
		
		// handle OptsMenu's back button press
		private function onGameQuit(e:Event):void {
			removeChild(playScreen);
			removePlayScreenEventListeners();
			addChild(mainMenu);
		}
		
		//handle LoginScreen's register button press
		private function onLoginScreenRegisterBtnPress(e:Event):void {
			Starling.current.nativeOverlay.removeChild(loginScreen);
			removeChild(loginButtonScreen);
			addChild(signupButtonScreen);
			Starling.current.nativeOverlay.addChild(signupScreen);
		}
		
		
		// handle LoginScreen's back button press
		private function onLoginScreenBackBtnPress(e:Event):void {
			loginScreen.userField.text = "";
			loginScreen.passwordField.text = "";
			loginScreen.messageField.text = "";
			removeChild(loginButtonScreen);
			Starling.current.nativeOverlay.removeChild(loginScreen);
			addChild(mainMenu);
		}
		
		//handle LoginScreen's submit button press
		private function onLoginScreenSubmitBtnPress(e:Event):void {
			var user:String = loginScreen.userField.text;
			var password:String = loginScreen.passwordField.text;
			loginScreen.login(user, password);
		}
		
		// handle SignupScreen's back button press
		private function onSignupScreenBackBtnPress(e:Event):void {
			signupScreen.messageField.text = "";
			signupScreen.userField.text = "";
			signupScreen.passwordField.text = "";
			signupScreen.emailField.text = "";
			removeChild(signupButtonScreen);
			Starling.current.nativeOverlay.removeChild(signupScreen);
			addChild(loginButtonScreen);
			Starling.current.nativeOverlay.addChild(loginScreen);
		}
		
		//handle SignupScreen's submit button press
		private function onSignupScreenSubmitBtnPress(e:Event):void {
			var user:String = signupScreen.userField.text;
			var password:String = signupScreen.passwordField.text;
			var email:String = signupScreen.emailField.text;
			signupScreen.signup(user, password, email);
		}
		
	}
	
}