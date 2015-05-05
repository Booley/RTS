package {

	import flash.display.Sprite;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.UncaughtErrorEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import starling.core.Starling;
	
	[SWF(backgroundColor="#000000")]
	public class PreMain extends Sprite {
		
		private var starl:Starling;

		public function PreMain() { 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			starl = new Starling(Main, stage, null, null, "auto", "auto");
			starl.start();
			
			Starling.current.showStats = true;
			Starling.current.nativeStage.frameRate = 60;
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleGlobalErrors);
		}
		
		public function handleGlobalErrors( evt : UncaughtErrorEvent ):void
		{
			evt.preventDefault();
			trace("caught some error homedawgizzle");
		}
		
		private function deactivate(e:Event):void 
		{
			// exit when app is sent to background (temporary)
			//NativeApplication.nativeApplication.exit();
		}

	}

}