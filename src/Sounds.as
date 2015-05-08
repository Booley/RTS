package  {
	
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.events.Event;
	
	public class Sounds {
		//[Embed(source="../assets/sounds/boop.wav", mimeType="application/octet-stream")]Sounds.play(Sounds.BOOP);
		public static const SONG1:int = 1;
		public static const BOOP:int = 2;
		public static const BACK:int = 3;
		
		private static const NUM_SONGS:int = 1;
		
		// Embed of all of the sound in the game
		//[Embed(source = "../assets/sounds/boop.wav", mimeType = "application/octet-stream")]
		[Embed(source="../assets/sounds/boop.mp3")]
		public static var Boop:Class;
		
		[Embed(source="../assets/sounds/backbutton.mp3")]
		public static var Back:Class;
		
		[Embed(source="../assets/sounds/boop.mp3")]
		public static var Song1:Class;
		
		
		
		
		//[Embed(source = "../assets/sounds/boop.wav", mimeType = "application/octet-stream")]
		
		private static var boop:Sound = new Boop();
		private static var back:Sound = new Back();
		private static var song1:Sound = new Song1();
		
		private static var soundChannel:SoundChannel;
		private static var musicChannel:SoundChannel;
		private static var currentSong:int = 0;
		
		public static function play(soundType:int):void {
			if (soundType == BOOP) {
				//boop.play();
				soundChannel = boop.play(0);
				soundChannel.soundTransform = new SoundTransform(0.5);
			} else if (soundType == BACK) {
				soundChannel = back.play(0);
				soundChannel.soundTransform = new SoundTransform(0.5);
			}
			else if (soundType == SONG1) {
				musicChannel = song1.play();
				musicChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			} 
		}
		
		public static function stopMusic():void {
			musicChannel.stop();
		}
		
		public static function startMusic():void {
			play(currentSong);
		}
		
		private static function soundCompleteHandler(event:Event):void {
			currentSong = (currentSong + 1)%NUM_SONGS
			play(currentSong);
		}
		
	}
	
}
