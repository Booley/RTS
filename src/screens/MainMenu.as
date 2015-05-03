package screens {
	
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	
	public class MainMenu extends Sprite {
		
		private var mainMenuSPBtn:Button;
		private var mainMenuMPBtn:Button;
		private var mainMenuLeaderboardBtn:Button;
		private var mainMenuOptsBtn:Button;
		private var mainMenuLoginBtn:Button;
		private var mainMenuSignupBtn:Button;
		
		private var background:Image;
		
		public function MainMenu() {
			super();
			
			// add background
			background = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			// initialize and add buttons
			mainMenuSPBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Single-Player");
			mainMenuSPBtn.fontSize = 50;
			mainMenuSPBtn.y = 0;
			mainMenuSPBtn.width = Constants.SCREEN_WIDTH;
			mainMenuSPBtn.height = Constants.SCREEN_HEIGHT/5;
			addChild(mainMenuSPBtn);
			
			mainMenuMPBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Multi-Player");
			mainMenuMPBtn.fontSize = 50;
			mainMenuMPBtn.y = Constants.SCREEN_HEIGHT/5;
			mainMenuMPBtn.width = Constants.SCREEN_WIDTH;
			mainMenuMPBtn.height = Constants.SCREEN_HEIGHT/5;
			addChild(mainMenuMPBtn);
			
			mainMenuLeaderboardBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Leaderboard");
			mainMenuLeaderboardBtn.fontSize = 50;
			mainMenuLeaderboardBtn.y = 2*Constants.SCREEN_HEIGHT/5;
			mainMenuLeaderboardBtn.width = Constants.SCREEN_WIDTH;
			mainMenuLeaderboardBtn.height = Constants.SCREEN_HEIGHT/5;
			//addChild(mainMenuLeaderboardBtn);
			
			mainMenuOptsBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Options");
			mainMenuOptsBtn.fontSize = 50;
			mainMenuOptsBtn.y = 2*Constants.SCREEN_HEIGHT/5;
			mainMenuOptsBtn.width = Constants.SCREEN_WIDTH;
			mainMenuOptsBtn.height = Constants.SCREEN_HEIGHT/5;
			addChild(mainMenuOptsBtn);
			
			mainMenuLoginBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Login");
			mainMenuLoginBtn.fontSize = 50;
			mainMenuLoginBtn.y = 3*Constants.SCREEN_HEIGHT/5;
			mainMenuLoginBtn.width = Constants.SCREEN_WIDTH;
			mainMenuLoginBtn.height = Constants.SCREEN_HEIGHT/5;
			addChild(mainMenuLoginBtn);
			
			mainMenuSignupBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Signup");
			mainMenuSignupBtn.fontSize = 50;
			mainMenuSignupBtn.y = 4*Constants.SCREEN_HEIGHT/5;
			mainMenuSignupBtn.width = Constants.SCREEN_WIDTH;
			mainMenuSignupBtn.height = Constants.SCREEN_HEIGHT/5;
			addChild(mainMenuSignupBtn);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			addListeners();
		}
		
		public function onRemoveFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			removeListeners();
		}
		
		private function addListeners():void {
			mainMenuSPBtn.addEventListener(TouchEvent.TOUCH, onSPBtnPress);
			mainMenuMPBtn.addEventListener(TouchEvent.TOUCH, onMPBtnPress);
			mainMenuLeaderboardBtn.addEventListener(TouchEvent.TOUCH, onLeaderboardBtnPress);
			mainMenuOptsBtn.addEventListener(TouchEvent.TOUCH, onOptsBtnPress);
			mainMenuLoginBtn.addEventListener(TouchEvent.TOUCH, onLoginBtnPress);
			mainMenuSignupBtn.addEventListener(TouchEvent.TOUCH, onSignupBtnPress);
		}
		
		private function removeListeners():void {
			mainMenuSPBtn.removeEventListener(TouchEvent.TOUCH, onSPBtnPress);
			mainMenuMPBtn.removeEventListener(TouchEvent.TOUCH, onMPBtnPress);
			mainMenuLeaderboardBtn.removeEventListener(TouchEvent.TOUCH, onLeaderboardBtnPress);
			mainMenuOptsBtn.removeEventListener(TouchEvent.TOUCH, onOptsBtnPress);
			mainMenuLoginBtn.removeEventListener(TouchEvent.TOUCH, onLoginBtnPress);
			mainMenuSignupBtn.removeEventListener(TouchEvent.TOUCH, onSignupBtnPress);
		}
		
		// handle mainMenuSPBtn press
		private function onSPBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuSPBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					dispatchEventWith(NavEvent.MAIN_MENU_SP);
				}
			}
		}
		
		// handle mainMenuMPBtn press
		private function onMPBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuMPBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN)	{
					dispatchEventWith(NavEvent.MAIN_MENU_MP);
				}
			}
		}
		
		// handle mainMenuLeaderboardBtn press
		private function onLeaderboardBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuLeaderboardBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					dispatchEventWith(NavEvent.MAIN_MENU_LEADERBOARD);
				}
			}
		}
		
		// handle mainMenuOptsBtn press
		private function onOptsBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuOptsBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN){
					dispatchEventWith(NavEvent.MAIN_MENU_OPTS);
				}
			}
		}
		
		// handle mainMenuLoginBtn press
		private function onLoginBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuLoginBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN){
					dispatchEventWith(NavEvent.MAIN_MENU_LOGIN);
				}
			}
		}
		
		private function onSignupBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuSignupBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN){
					dispatchEventWith(NavEvent.MAIN_MENU_SIGNUP);
				}
			}
		}
	}
}