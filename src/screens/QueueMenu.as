package screens {
	
	import feathers.controls.Check;
	
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
		private var check:Check;
		
		private var buttonheight:int = 75;
		private var buttonwidth:int = 75;
		private var priceheight:int = 5;

		private var infpriceText:TextField;
		private var snipriceText:TextField;
		private var raipriceText:TextField;
		
		private var playerBase:Base;
		private var queuePreview:Sprite;
		
		private var ang:Number;
		
		public function QueueMenu(base:Base) {
			super();
			
			this.playerBase = base;
			
			// initialize and add buttons
			button1 = new Button(Assets.getAtlas().getTexture(Infantry.TEXTURE_NAME + base.owner));
			button1.y = Constants.SCREEN_HEIGHT - buttonheight + priceheight;
			button1.width = buttonwidth;
			button1.height = buttonheight;
			addChild(button1);
  			infpriceText = new TextField(100, 50, "" + Infantry.COST, "Verdana", 20, 0xffffff);
			infpriceText.x = button1.x + 40;
			infpriceText.y = button1.y + 10;
			infpriceText.touchable = false;
			addChild(infpriceText);
		
			button2 = new Button(Assets.getAtlas().getTexture(Sniper.TEXTURE_NAME + base.owner));
			button2.y = Constants.SCREEN_HEIGHT - 2 * buttonheight + priceheight;
			button2.width = buttonwidth;
			button2.height = buttonheight;
			addChild(button2);
			snipriceText = new TextField(100, 50, "" + Sniper.COST, "Verdana", 20, 0xffffff);
			snipriceText.x = button2.x + 40;
			snipriceText.y = button2.y + 10;
			snipriceText.touchable = false;
			addChild(snipriceText);
			
			button3 = new Button(Assets.getAtlas().getTexture(Raider.TEXTURE_NAME + base.owner));
			button3.y = Constants.SCREEN_HEIGHT - 3 * buttonheight + priceheight;
			button3.width = buttonwidth;
			button3.height = buttonheight;
			addChild(button3);
			raipriceText = new TextField(100, 50, "" + Raider.COST, "Verdana", 20, 0xffffff);
			raipriceText.x = button3.x + 40;
			raipriceText.y = button3.y + 10;
			raipriceText.touchable = false;
			addChild(raipriceText);
			
			//will update UI
			messageText = new TextField(300, 200, "", "Verdana", 15, 0xffffff);
			messageText.y = 350;
			messageText.x = 120;
			addChild(messageText);
			
			// initializa the text the list of the price of each unit
			
			/***************************************/
			//un comment to get to work again//

			
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
					if (playerBase.totalResources < Infantry.COST) {
						messageText.text = "Not Enough\nResources";
					}
					else {
						messageText.text = "";
						playerBase.totalResources -= Infantry.COST;
						playerBase.queueUnit(Unit.INFANTRY);
					}
				
				}
			}
		}
		
		private function onButton2Press(e:TouchEvent):void {
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(button2);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					if (playerBase.totalResources < Sniper.COST) {
						messageText.text = "Not Enough\nResources";
					}
					else {
						messageText.text = "";
						playerBase.totalResources -= Sniper.COST;
						playerBase.queueUnit(Unit.SNIPER);
					}
					
				}
			}
		}
		
		private function onButton3Press(e:TouchEvent):void {
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(button3);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					if (playerBase.totalResources < Raider.COST) {
						messageText.text = "Not Enough\nResources";
					}
					else {
						messageText.text = "";
						playerBase.totalResources -= Raider.COST;
						playerBase.queueUnit(Unit.RAIDER);
					}
				}
			}
		}
		
		private function checkChangeHandler(e:Event):void {
			//playerBase.infiniteBuild = check.isSelected;
		}
		
		public function tick(dt:Number):void {
			
		}

	}
}