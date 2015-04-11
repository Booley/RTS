package screens {
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	
	import units.*;
	
	public class QueueMenu extends Sprite {
		
		private var button1:Button;
		private var button2:Button;
		private var button3:Button;
		private var button4:Button;
		private var button5:Button;
		private var button6:Button;
		
		private var portal:Base;
		private var queuePreview:Sprite;
		
		public function QueueMenu(base:Base) {
			super();
			
			this.portal = base;
			
			// initialize and add buttons
			button1 = new Button(Assets.getTexture(Infantry.TEXTURE_NAME + "1"));
			button1.y = 0;
			button1.width = 100;
			button1.height = 100;
			addChild(button1);
			
			button2 = new Button(Assets.getTexture(Sniper.TEXTURE_NAME + "1"));
			button2.y = 100;
			button2.width = 100;
			button2.height = 100;
			addChild(button2);
			
			button3 = new Button(Assets.getTexture(Raider.TEXTURE_NAME + "1"));
			button3.y = 200;
			button3.width = 100;
			button3.height = 100;
			addChild(button3);
			
			queuePreview = new Sprite();
			queuePreview.y = 440;
			addChild(queuePreview);
			
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
			button1.addEventListener(TouchEvent.TOUCH, onButton1Press);
			button2.addEventListener(TouchEvent.TOUCH, onButton2Press);
			button3.addEventListener(TouchEvent.TOUCH, onButton3Press);
		}
		
		private function removeListeners():void {
			button1.removeEventListener(TouchEvent.TOUCH, onButton1Press);
			button2.removeEventListener(TouchEvent.TOUCH, onButton2Press);
			button3.removeEventListener(TouchEvent.TOUCH, onButton3Press);
		}
		
		private function onButton1Press(e:TouchEvent):void {
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(button1);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					portal.queueUnit(Unit.INFANTRY);
				}
			}
		}
		
		private function onButton2Press(e:TouchEvent):void {
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(button2);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					portal.queueUnit(Unit.SNIPER);
				}
			}
		}
		
		private function onButton3Press(e:TouchEvent):void {
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(button3);
			if (touch) {
				if(touch.phase == TouchPhase.BEGAN) {
					portal.queueUnit(Unit.RAIDER);
				}
			}
		}
		
		public function tick(dt:Number):void {
			
		}

	}
}