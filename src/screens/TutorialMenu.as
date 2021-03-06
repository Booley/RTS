package screens {
	
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	
	public class TutorialMenu extends Sprite {
	
		public function TutorialMeno():void {
			// get map background
			background = new Image(Assets.getAtlas().getTexture(Assets.Map1Background));
			background.width = Constants.SCREEN_WIDTH;
			background.height =  Constants.SCREEN_HEIGHT;
			addChildAt(background, 0);
			
			// get map background
			tutorialscreen = new Image(Assets.getAtlas().getTexture(Assets.TutorialScreen));
			tutorialscreen.width = Constants.SCREEN_WIDTH;
			tutorialscreen.height =  Constants.SCREEN_HEIGHT;
			addChildAt(tutorialscreen, 0);
	
		}
	}
		
		private var backBtn:Button;
		private var playBtn:Button;
		private var background:Image;
		private var tutorialscreen:Image;

		
		public function MPMenu() {
			super();
			
			// add background
			background = new Image(Assets.getAtlas().getTexture(Assets.MenuBackground));
			background.width = Constants.SCREEN_WIDTH;
			background.height = Constants.SCREEN_HEIGHT;
			addChild(background);
			
			// initialize and add buttons
			playBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Play");
			playBtn.fontSize = 50;
			playBtn.y = 0;
			playBtn.width = Constants.SCREEN_WIDTH;
			playBtn.height = Constants.SCREEN_HEIGHT/5
			addChild(playBtn);
			
			backBtn = new Button(Assets.getAtlas().getTexture(Assets.ButtonTexture), "Back");
			backBtn.fontSize = 50;
			backBtn.y = Constants.SCREEN_HEIGHT/5;
			backBtn.width = Constants.SCREEN_WIDTH;
			backBtn.height = Constants.SCREEN_HEIGHT/5
			addChild(backBtn);
			
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
			backBtn.addEventListener(TouchEvent.TOUCH, onBackBtnPress);
			playBtn.addEventListener(TouchEvent.TOUCH, onPlayBtnPress);
		}
		
		private function removeListeners():void {
			backBtn.removeEventListener(TouchEvent.TOUCH, onBackBtnPress);
			playBtn.removeEventListener(TouchEvent.TOUCH, onPlayBtnPress);
		}
		
		// handle backBtn press
		private function onBackBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(backBtn);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					dispatchEventWith(NavEvent.MP_MENU_BACK);
				}
			}
		}
		
		// handle playBtn press
		private function onPlayBtnPress(e:TouchEvent):void {
			var touch:Touch = e.getTouch(playBtn);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					dispatchEventWith(NavEvent.MP_MENU_PLAY);
				}
			}
		}

	}
}