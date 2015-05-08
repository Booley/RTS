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
		public static const Title:String = "title";
		public static const Instructions:String = "info";
				
		public static const Map1Background:String = "map1/background";
		[Embed(source="../assets/images/maps/map1/obstacles.png")]
		public static const Map1Obstacles:Class;
		
		public static const Map2Background:String = "map2/background";
		[Embed(source="../assets/images/maps/map2/obstacles.png")]
		public static const Map2Obstacles:Class;
		
		public static const Map3Background:String = "map3/background";
		[Embed(source="../assets/images/maps/map3/obstacles.png")]
		public static const Map3Obstacles:Class;
		
		public static const Map4Background:String = "map4/background";
		[Embed(source="../assets/images/maps/map4/obstacles.png")]
		public static const Map4Obstacles:Class;
		
		public static const Map5Background:String = "map5/background";
		[Embed(source="../assets/images/maps/map5/obstacles.png")]
		public static const Map5Obstacles:Class;
		
		[Embed(source="../assets/images/backgrounds/picker_bg.png")]
		public static const TestBG:Class;
		
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
		
		// avoid creating a texture from a bitmap more than once for optimization.
		public static function getTexture2(name:Class):Texture {
			if (gameTextures[name] == undefined) {
				gameTextures[name] = Texture.fromBitmap(new name());
			}
			return gameTextures[name];
		}
		
	}
}