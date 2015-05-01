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
	import starling.text.TextField;
	
	import unitstuff.Base;
	import unitstuff.Infantry;
	import unitstuff.Raider;
	import unitstuff.Sniper;
	import unitstuff.Unit;
	import unitstuff.*;
	
	public class QueueMenu extends Sprite {
		
		private var button1:Button;
		private var button2:Button;
		private var button3:Button;
		private var messageText:TextField;
		
		private var butttonheight:int = 75;
		private var butttonwidth:int = 75;
		private var priceheight:int = 5;

		private var infpriceText:TextField;
		private var snipriceText:TextField;
		private var raipriceText:TextField;
		
		private var portal:Base;
		private var queuePreview:Sprite;
		
		private var ang:Number;
		
		public function QueueMenu(base:Base) {
			super();
			
			this.portal = base;
			
			// initialize and add buttons
			button1 = new Button(Assets.getTexture(Infantry.TEXTURE_NAME + base.owner));
			button1.y = Constants.SCREEN_HEIGHT - butttonheight + priceheight;
			button1.width = butttonwidth;
			button1.height = butttonheight;
			addChild(button1);
			
			button2 = new Button(Assets.getTexture(Sniper.TEXTURE_NAME + base.owner));
			button2.y = Constants.SCREEN_HEIGHT - 2 * butttonheight + priceheight;
			button2.width = butttonwidth;
			button2.height = butttonheight;
			addChild(button2);
			
			button3 = new Button(Assets.getTexture(Raider.TEXTURE_NAME + base.owner));
			button3.y = Constants.SCREEN_HEIGHT - 3 * butttonheight + priceheight;
			button3.width = butttonwidth;
			button3.height = butttonheight;
			addChild(button3);
			
			//will update UI
			messageText = new TextField(300, 200, "", "Verdana", 15, 0xffffff);
			messageText.y = 350;
			messageText.x = 120;
			addChild(messageText);

			
			// initializa the text the list of the price of each unit
			
			/***************************************/
			//un comment to get to work again//
			//infpriceText = new TextField(300, 300, "123","Verdana", 20, 0xffffff);
			//snipriceText = new TextField(0, 0, "333","Verdana", 200, 0xffffff);
			//raipriceText = new TextField(0, 2, "123");
			
			
			
			//addChild(infpriceText);
			//addChild(snipriceText);
			//addChild(raipriceText);
			
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
				if (touch.phase == TouchPhase.BEGAN) {
					if (portal.totalResources < Infantry.COST) {
						messageText.text = "Not Enough\nResources";
					}
					else {
						messageText.text = "";
						portal.totalResources -= Infantry.COST;
						portal.queueUnit(Unit.INFANTRY);
					}
				
				}
			}
		}
		
		private function onButton2Press(e:TouchEvent):void {
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(button2);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					if (portal.totalResources < Sniper.COST) {
						messageText.text = "Not Enough\nResources";
					}
					else {
						messageText.text = "";
						portal.totalResources -= Sniper.COST;
						portal.queueUnit(Unit.SNIPER);
					}
					
				}
			}
		}
		
		private function onButton3Press(e:TouchEvent):void {
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(button3);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					if (portal.totalResources < Raider.COST) {
						messageText.text = "Not Enough\nResources";
					}
					else {
						messageText.text = "";
						portal.totalResources -= Raider.COST;
						portal.queueUnit(Unit.RAIDER);
					}
					
				}
			}
		}
		
		public function tick(dt:Number):void {
			
		}

	}
}