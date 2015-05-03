package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets {
		
		public static const ButtonTexture:String = "buttons/button";
		public static const MenuBackground:String = "backgrounds/menu_background";
		public static const BaseTexture:String = "units/base";
		public static const InfantryTexture:String = "units/square";
		public static const RaiderTexture:String = "units/circle";
		public static const SniperTexture:String = "units/triangle";
		public static const HighlightTexture:String = "units/highlight";
		public static const BulletTexture:String = "units/bullet";
		public static const ResourcePointTexture:String = "units/neutral_point";
		public static const HealthBackgroundTexture:String = "units/healthBackground";
		public static const HealthBarTexture:String = "units/healthBar";
		
		public static const Map1Background:String = "maps/map1/background";
		public static const Map1Obstacles:String = "maps/map1/obstacles";
		
		private static var gameTextureAtlas:TextureAtlas;
		private static var gameTextures:Dictionary = new Dictionary();
		
		// Embed the Atlas XML
		[Embed(source="../assets/images/resources.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="../assets/images/resources.png")]
		public static const AtlasTexture:Class;
		
		public static function getAtlas():TextureAtlas {
			if (gameTextureAtlas == null) {
				var texture:Texture = getTexture("AtlasTexture");
				var xml:XML = XML(new AtlasXml());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		// avoid creating a texture from a bitmap more than once for optimization.
		public static function getTexture(name:String):Texture {
			if (gameTextures[name] == undefined) {
				gameTextures[name] = Texture.fromEmbeddedAsset(Assets[name]);
			}
			return gameTextures[name];
		}
		
	}
}