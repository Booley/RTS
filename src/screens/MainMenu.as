package screens {
	
	import feathers.controls.Check;
	import feathers.controls.Button;
	
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	
	public class MainMenu extends Sprite {
		
		private var mainMenuSPBtn:Button;
		private var mainMenuMPBtn:Button;
		private var mainMenuLeaderboardBtn:Button;
		private var mainMenuInstructionsBtn:Button;
		private var mainMenuLoginBtn:Button;
		private var mainMenuSignupBtn:Button;
		
		private var background:Image;
		
		public function MainMenu() {
			super();
			
			// add background
			background = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			//addChild(background);
			
			// initialize and add buttons
			mainMenuSPBtn = new Button();
			mainMenuSPBtn.label = "Single-Player";
			//mainMenuSPBtn.fontSize = 50;
			mainMenuSPBtn.y = 0;
			mainMenuSPBtn.width = Constants.SCREEN_WIDTH;
			mainMenuSPBtn.height = Constants.SCREEN_HEIGHT/5;
			addChild(mainMenuSPBtn);
			/*
			mainMenuMPBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Multi-Player");
			mainMenuMPBtn.fontSize = 50;
			mainMenuMPBtn.y = Constants.SCREEN_HEIGHT/5;
			mainMenuMPBtn.width = Constants.SCREEN_WIDTH;
			mainMenuMPBtn.height = Constants.SCREEN_HEIGHT/5;
			//addChild(mainMenuMPBtn);
			
			mainMenuLeaderboardBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Leaderboards");
			mainMenuLeaderboardBtn.fontSize = 50;
			mainMenuLeaderboardBtn.y = 2*Constants.SCREEN_HEIGHT/5;
			mainMenuLeaderboardBtn.width = Constants.SCREEN_WIDTH;
			mainMenuLeaderboardBtn.height = Constants.SCREEN_HEIGHT/5;
			//addChild(mainMenuLeaderboardBtn);
			
			mainMenuInstructionsBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Instructions");
			mainMenuInstructionsBtn.fontSize = 50;
			mainMenuInstructionsBtn.y = 3*Constants.SCREEN_HEIGHT/5;
			mainMenuInstructionsBtn.width = Constants.SCREEN_WIDTH;
			mainMenuInstructionsBtn.height = Constants.SCREEN_HEIGHT/5;
			//addChild(mainMenuInstructionsBtn);
			
			mainMenuLoginBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Login");
			mainMenuLoginBtn.fontSize = 50;
			mainMenuLoginBtn.y = 4*Constants.SCREEN_HEIGHT/5;
			mainMenuLoginBtn.width = Constants.SCREEN_WIDTH;
			mainMenuLoginBtn.height = Constants.SCREEN_HEIGHT/5;
			//addChild(mainMenuLoginBtn);
			
			
			mainMenuSignupBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Signup");
			mainMenuSignupBtn.fontSize = 50;
			mainMenuSignupBtn.y = 4*Constants.SCREEN_HEIGHT/5;
			mainMenuSignupBtn.width = Constants.SCREEN_WIDTH;
			mainMenuSignupBtn.height = Constants.SCREEN_HEIGHT/5;
			//addChild(mainMenuSignupBtn);
			*/
			var check:Check = new Check();
			check.label = "Loop Queue";
			check.x = 100,
			check.y = 4*Constants.SCREEN_HEIGHT/5;
			check.setSize(100, 100);
			check.isSelected = true;
			addChild(check);
			
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
			/*mainMenuMPBtn.addEventListener(TouchEvent.TOUCH, onMPBtnPress);
			mainMenuLeaderboardBtn.addEventListener(TouchEvent.TOUCH, onLeaderboardBtnPress);
			mainMenuInstructionsBtn.addEventListener(TouchEvent.TOUCH, onInstructionsBtnPress);
			mainMenuLoginBtn.addEventListener(TouchEvent.TOUCH, onLoginBtnPress);
			mainMenuSignupBtn.addEventListener(TouchEvent.TOUCH, onSignupBtnPress);*/
		}
		
		private function removeListeners():void {
			mainMenuSPBtn.removeEventListener(TouchEvent.TOUCH, onSPBtnPress);
			mainMenuMPBtn.removeEventListener(TouchEvent.TOUCH, onMPBtnPress);
			mainMenuLeaderboardBtn.removeEventListener(TouchEvent.TOUCH, onLeaderboardBtnPress);
			mainMenuInstructionsBtn.removeEventListener(TouchEvent.TOUCH, onInstructionsBtnPress);
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
		
		// handle mainMenuInstructionsBtn press
		private function onInstructionsBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(mainMenuInstructionsBtn);
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