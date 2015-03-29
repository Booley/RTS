package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class Assets {
		
		[Embed(source="/../assets/images/buttons/button.png")]
		public static const ButtonTexture:Class;
		
		[Embed(source="/../assets/images/backgrounds/menu_background.jpg")]
		public static const MenuBackground:Class;
		
		[Embed(source="/../assets/images/units/square.png")]
		public static const InfantryTexture:Class;
		
		[Embed(source="/../assets/images/units/circle.png")]
		public static const RaiderTexture:Class;
		
		[Embed(source="/../assets/images/units/triangle.png")]
		public static const SniperTexture:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();

		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}