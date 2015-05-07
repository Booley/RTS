package screens {
	
	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.*;
	import starling.core.Starling;

	public class LoginScreen extends Sprite {
		private static const LOGIN_URL:String = "http://samuelfc.mycpanel.princeton.edu/public_html/cos333/login.php"; 
		private static const SIGNUP_URL:String = "http://samuelfc.mycpanel.princeton.edu/public_html/cos333/create_user.php";
		
		private static const ON_LOGIN_SUCCESS:int = 1;
		private static const ON_LOGIN_FAIL:int = -1;
		private static const ON_CREATE_SUCCESS:int = 2;
		private static const ON_CREATE_FAILURE:int = -2;
		
		public var userField:TextField;
		public var passwordField:TextField;
		private var messageField:TextField;
		private var userText:TextField;
		private var passwordText:TextField;
		private var leaderboard:LeaderboardMenu;
		
		public static var myUsername:String = "";
		
		public function LoginScreen(leaderboard:LeaderboardMenu) {
			super();
			this.leaderboard = leaderboard;
			
			messageField = new TextField();
			userField = new TextField();
			passwordField = new TextField();
			userText = new TextField();
			passwordText = new TextField();
			
			var textFormat:TextFormat = new TextFormat("Arial", 20, 0x000000);
			textFormat.align = TextFormatAlign.LEFT;
			
			userField.defaultTextFormat = textFormat;
			passwordField.defaultTextFormat = textFormat;
			messageField.defaultTextFormat = textFormat;
			userText.defaultTextFormat = textFormat;
			passwordText.defaultTextFormat = textFormat;
			
			userField.background = true;
			passwordField.background = true;
			
			userField.backgroundColor = 0x00FFFF;
			passwordField.backgroundColor = 0x00FFFF;
			
			userText.textColor = 0x00FFFF;
			passwordText.textColor = 0x00FFFF;
			
			userText.text = "Username";
			passwordText.text = "Password";
			
			userField.height = 50;
			passwordField.height = 50;
			
			userField.x = 150;
			passwordField.x = 150;
			
			userField.type = TextFieldType.INPUT;
			passwordField.type = TextFieldType.INPUT;
			
			messageField.width = 300;
			
			userField.y = 0;
			userText.y = 0;
			passwordField.y = 100;
			passwordText.y = 100;
			messageField.y = 200;
			
			userField.restrict = "A-Za-z0-9";
			passwordField.restrict = "A-Za-z0-9";
			
			userField.maxChars = 15;
			passwordField.maxChars = 15;
			
			passwordField.displayAsPassword = true;
			
			addChild(userField);
			addChild(passwordField);
			addChild(messageField);
			addChild(userText);
			addChild(passwordText);
		}
		
		// authenticate user
		public function login(userName:String, password:String):void {
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.userName = userName;
			urlVariables.password = password;
			
			var phpFileRequest:URLRequest = new URLRequest(LOGIN_URL);
			phpFileRequest.method = URLRequestMethod.POST;
			phpFileRequest.data = urlVariables;
			
			var phpLoader:URLLoader = new URLLoader();
			phpLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			phpLoader.addEventListener(Event.COMPLETE, showResult);
			phpLoader.load(phpFileRequest);
		}
		
		public function setMessasge(message:String):void {
			messageField.text = message;
		}
		
		/*
			function to show the result of the login
		*/
 
		public function showResult(event:Event):void {
			 
			/*
			this gets the output and displays it in the result text field
			*/
			var urlLoader:URLLoader = URLLoader(event.target);
			messageField.text = urlLoader.data.msg;
			
			if (messageField.text == "Login successful.")
			{
				trace("recording username...");
				PlayScreen.isRanked = true;
				myUsername = userField.text; //be sure to assign something else when logged out!!!
				leaderboard.username = myUsername;
			}
			trace(urlLoader.data.msg);
		 
		}
		
	}
}