package {

	import flash.display.Sprite;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import starling.core.Starling;

	public class PreMain extends Sprite {
		
		private var starl:Starling;

		public function PreMain() { 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			starl = new Starling(Main, stage);
			starl.antiAliasing = 1;
			starl.start();
			
			Starling.current.showStats = true;
		}
		
		
		private function deactivate(e:Event):void 
		{
			// exit when app is sent to background (temporary)
			//NativeApplication.nativeApplication.exit();
		}

	}

}