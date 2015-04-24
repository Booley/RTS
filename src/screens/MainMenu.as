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
			background = new Image(Assets.getTexture("MenuBackground"));
			addChild(background);
			
			// initialize and add buttons
			mainMenuSPBtn = new Button(Assets.getTexture("ButtonTexture"), "Single-Player");
			mainMenuSPBtn.y = 0;
			addChild(mainMenuSPBtn);
			
			mainMenuMPBtn = new Button(Assets.getTexture("ButtonTexture"), "Multi-Player");
			mainMenuMPBtn.y = 100;
			addChild(mainMenuMPBtn);
			
			mainMenuLeaderboardBtn = new Button(Assets.getTexture("ButtonTexture"), "Leaderboard");
			mainMenuLeaderboardBtn.y = 200;
			addChild(mainMenuLeaderboardBtn);
			
			mainMenuOptsBtn = new Button(Assets.getTexture("ButtonTexture"), "Options");
			mainMenuOptsBtn.y = 300;
			mainMenuOptsBtn.height = 50;
			addChild(mainMenuOptsBtn);
			
			mainMenuLoginBtn = new Button(Assets.getTexture("ButtonTexture"), "Login");
			mainMenuLoginBtn.y = 350;
			mainMenuLoginBtn.height = 50;
			addChild(mainMenuLoginBtn);
			
			mainMenuSignupBtn = new Button(Assets.getTexture("ButtonTexture"), "Signup");
			mainMenuSignupBtn.y = 400;
			mainMenuSignupBtn.y = 400;
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
					dispatchEvent(new NavEvent(NavEvent.MAIN_MENU_SP));
				}
			}
		}
		
		// handle mainMenuMPBtn press
		private function onMPBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuMPBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN)	{
					dispatchEvent(new NavEvent(NavEvent.MAIN_MENU_MP));
				}
			}
		}
		
		// handle mainMenuLeaderboardBtn press
		private function onLeaderboardBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuLeaderboardBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					dispatchEvent(new NavEvent(NavEvent.MAIN_MENU_LEADERBOARD));
				}
			}
		}
		
		// handle mainMenuOptsBtn press
		private function onOptsBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuOptsBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN){
					dispatchEvent(new NavEvent(NavEvent.MAIN_MENU_OPTS));
				}
			}
		}
		
		// handle mainMenuLoginBtn press
		private function onLoginBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuLoginBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN){
					dispatchEvent(new NavEvent(NavEvent.MAIN_MENU_LOGIN));
				}
			}
		}
		
		private function onSignupBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuSignupBtn);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN){
					dispatchEvent(new NavEvent(NavEvent.MAIN_MENU_SIGNUP));
				}
			}
		}
	}
}