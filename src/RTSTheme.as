package {
	
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.text.StageTextField;
	import feathers.themes.StyleNameFunctionTheme;
	import feathers.controls.Button;
	import flash.text.TextFormat;
	
	import starling.display.Image;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
    public class RTSTheme extends StyleNameFunctionTheme {
		
        public function RTSTheme() {
            super();
			initialize();
        }

        private function initialize():void {
			this.initializeStyleProviders();
        }
		
		private function initializeStyleProviders():void {
			// button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			//FeathersControl.defaultTextRendererFactory = TextFieldTextRenderer;
		}
		
		private function setButtonStyles( button:Button ):void {
			
			button.defaultSkin = new Image(Assets.getAtlas().getTexture(Assets.ButtonTexture));
			button.downSkin = new Image(Assets.getAtlas().getTexture(Assets.ButtonTexture));

			button.padding = 20;
			button.gap = 15;
			
			//button.defaultLabelProperties.textRenderedr = new TextFieldTextRenderer()"Verdana", 18, 0x333333);
		}
    }
}