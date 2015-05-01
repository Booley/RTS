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
		
		[Embed(source="/../assets/images/units/base1.png")]
		private static const BaseTexture1:Class;
		
		[Embed(source="/../assets/images/units/base2.png")]
		private static const BaseTexture2:Class;
		
		[Embed(source="/../assets/images/units/square1.png")]
		private static const InfantryTexture1:Class;
		
		[Embed(source="/../assets/images/units/square2.png")]
		private static const InfantryTexture2:Class;
		
		[Embed(source="/../assets/images/units/circle1.png")]
		private static const RaiderTexture1:Class;
		
		[Embed(source="/../assets/images/units/circle2.png")]
		private static const RaiderTexture2:Class;
		
		[Embed(source="/../assets/images/units/triangle1.png")]
		private static const SniperTexture1:Class;
		
		[Embed(source="/../assets/images/units/triangle2.png")]
		private static const SniperTexture2:Class;
		
		[Embed(source="/../assets/images/units/highlight.png")]
		private static const HighlightTexture:Class;

		[Embed(source = "../assets/images/units/bullet.png")]
		private static const BulletTexture:Class;
/*	
		[Embed(source = "/../assets/images/units/neutral_point1.png")]
		private static const ResourcePointTexture1:Class;
		
		[Embed(source = "/../assets/images/units/neutral_point2.png")]
		private static const ResourcePointTexture2:Class;
		
		[Embed(source = "/../assets/images/units/neutral_point3.png")]
		private static const ResourcePointTexture3:Class;
		*/
		// MAPSSSSSSSSSS
		[Embed(source="../assets/images/maps/map1/background.png")]
		public static const Map1Background:Class;

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