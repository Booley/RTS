package {
	
	import feathers.themes.StyleNameFunctionTheme;
	import feathers.controls.Button;
	
	import starling.display.Image;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
    public class RTSTheme extends StyleNameFunctionTheme {
		
        public function RTSTheme() {
            super();
        }

        private function initialize():void {
			this.initializeStyleProviders();
        }
		
		private function initializeStyleProviders():void {
			// button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
		}
		
		private function setButtonStyles( button:Button ):void {
		
			button.defaultSkin = new Image(Assets.getAtlas().getTexture(Assets.ButtonTexture));
			button.downSkin = new Image(Assets.getAtlas().getTexture(Assets.ButtonTexture));

			button.padding = 20;
			button.gap = 15;

			button.defaultLabelProperties.elementFormat =
				new ElementFormat( new FontDescription("_sans" ), 18, 0x333333 );
		}
    }
}