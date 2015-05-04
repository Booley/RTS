package {
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets {
		
		public static const ButtonTexture:String = "button";
		public static const MenuBackground:String = "menu_background";
		public static const BaseTexture:String = "base";
		public static const InfantryTexture:String = "square";
		public static const RaiderTexture:String = "circle";
		public static const SniperTexture:String = "triangle";
		public static const HighlightTexture:String = "highlight";
		public static const BulletTexture:String = "bullet";
		public static const ResourcePointTexture:String = "neutral_point";
		public static const HealthBackgroundTexture:String = "healthBackground";
		public static const HealthBarTexture:String = "healthBar";
		
		public static const Map1Background:String = "map1/background";
		[Embed(source="../assets/images/maps/map1/obstacles.png")]
		public static const Map1Obstacles:Class;
		
		public static const Map2Background:String = "map2/background";
		[Embed(source="../assets/images/maps/map2/obstacles.png")]
		public static const Map2Obstacles:Class;
		
		private static var gameTextureAtlas:TextureAtlas;
		private static var gameTextures:Dictionary = new Dictionary();
		
		// Embed the Atlas XML
		[Embed(source="../assets/images/resources.xml", mimeType="application/octet-stream")]
		private static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="../assets/images/resources.png")]
		private static const AtlasTexture:Class;
		
		public static function getAtlas():TextureAtlas {
			if (gameTextureAtlas == null) {
				var texture:Texture = getTexture("AtlasTexture");
				var xml:XML = XML(new AtlasXml());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		// avoid creating a texture from a bitmap more than once for optimization.
		private static function getTexture(name:String):Texture {
			if (gameTextures[name] == undefined) {
				gameTextures[name] = Texture.fromEmbeddedAsset(Assets[name]);
			}
			return gameTextures[name];
		}
		
	}
}