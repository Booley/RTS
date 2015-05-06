package screens
{
	import flash.events.Event;
	import flash.net.*;
	import flash.text.TextField;
	import screens.LeaderboardMenu;
	
	public class Leaders 
	{
		private var leaderScreen:LeaderboardMenu;
		private static const LEADER_URL:String = "http://samuelfc.mycpanel.princeton.edu/public_html/cos333/leaderboard.php"; 
		
		public function Leaders(leaderScreen:LeaderboardMenu):void {
			this.leaderScreen = leaderScreen;
			update();
		}
		
		public function update():void {
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = leaderScreen.username;
				
			var phpFileRequest:URLRequest = new URLRequest(LEADER_URL);
			phpFileRequest.method = URLRequestMethod.POST;
			phpFileRequest.data = urlVariables;
			
			var phpLoader:URLLoader = new URLLoader();
			phpLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			phpLoader.addEventListener(Event.COMPLETE, showResult);
			phpLoader.load(phpFileRequest);
		}
		
		private function showResult(event:Event):void {
			var urlLoader:URLLoader = URLLoader(event.target);
			leaderScreen.rank.text = urlLoader.data.rank;
			leaderScreen.user.text = urlLoader.data.user;
			leaderScreen.elo.text = urlLoader.data.elo;
		}
		
	}

}