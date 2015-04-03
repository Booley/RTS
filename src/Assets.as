package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class Assets {
		
		[Embed(source="/../assets/images/buttons/button.png")]
		private static const ButtonTexture:Class;
		
		[Embed(source="/../assets/images/backgrounds/menu_background.jpg")]
		private static const MenuBackground:Class;
		
		[Embed(source="/../assets/images/units/base.png")]
		private static const BaseTexture:Class;
		
		[Embed(source="/../assets/images/units/square.png")]
		private static const InfantryTexture:Class;
		
		[Embed(source="/../assets/images/units/circle.png")]
		private static const RaiderTexture:Class;
		
		[Embed(source="/../assets/images/units/triangle.png")]
		private static const SniperTexture:Class;
		
		[Embed(source = "../assets/images/units/bullet.png")]
		private static const BulletTexture:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();

		// avoid creating a texture from a bitmap more than once for optimization.
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