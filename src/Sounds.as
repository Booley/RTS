package  {
	
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.events.Event;
	
	public class Sounds {
		
		public static const SONG1:int = 1;
		public static const BOOP:int = 2;
		
		private static const NUM_SONGS:int = 1;
		
		
		
		private static const boop:Boop = new Boop();
		private static const song1:Song1 = new Song1();
		
		private static var soundChannel:SoundChannel;
		private static var musicChannel:SoundChannel;
		private static var currentSong:int = 0;
		
		public static function play(sound:int) {
			if (sound == BOOP) {
				soundChannel = boop.play(0);
				soundChannel.soundTransform = new SoundTransform(0.5);
			} else if (sound == SONG1) {
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
		
		private static function soundCompleteHandler(event:Event) {
			currentSong = (currentSong + 1)%NUM_SONGS
			play(currentSong);
		}
		
	}
	
}
