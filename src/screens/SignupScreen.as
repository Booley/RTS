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

	public class SignupScreen extends Sprite {
		private static const LOGIN_URL:String = "http://samuelfc.mycpanel.princeton.edu/public_html/cos333/login.php"; 
		private static const SIGNUP_URL:String = "http://samuelfc.mycpanel.princeton.edu/public_html/cos333/create_user.php";
		
		private static const ON_LOGIN_SUCCESS:int = 1;
		private static const ON_LOGIN_FAIL:int = -1;
		private static const ON_CREATE_SUCCESS:int = 2;
		private static const ON_CREATE_FAILURE:int = -2;
		
		public var userField:TextField;
		public var passwordField:TextField;
		public var emailField:TextField;
		public var messageField:TextField;
		public var userText:TextField;
		public var passwordText:TextField;
		public var emailText:TextField;
		
		
		public function SignupScreen() {
			super();
		
			messageField = new TextField();
			userField = new TextField();
			passwordField = new TextField();
			emailField = new TextField();
			userText = new TextField();
			passwordText = new TextField();
			emailText = new TextField();
			
			var textFormat:TextFormat = new TextFormat("Arial", 20, 0x000000);
			textFormat.align = TextFormatAlign.LEFT;
			
			userField.defaultTextFormat = textFormat;
			passwordField.defaultTextFormat = textFormat;
			messageField.defaultTextFormat = textFormat;
			emailField.defaultTextFormat = textFormat;
			userText.defaultTextFormat = textFormat;
			passwordText.defaultTextFormat = textFormat;
			emailText.defaultTextFormat = textFormat;
			
			userField.type = TextFieldType.INPUT;
			passwordField.type = TextFieldType.INPUT;
			emailField.type = TextFieldType.INPUT;
			
			
			messageField.text = "";
			messageField.width = Constants.SCREEN_WIDTH;
			
			userField.background = true;
			passwordField.background = true;
			emailField.background = true;
			
			userField.backgroundColor = 0x00ffff;
			passwordField.backgroundColor = 0x00ffff;
			emailField.backgroundColor = 0x00ffff;
			
			userField.width = 2*Constants.SCREEN_WIDTH/3;
			passwordField.width = 2*Constants.SCREEN_WIDTH/3;
			emailField.width = 2*Constants.SCREEN_WIDTH/3;
			
			userField.height = Constants.SCREEN_HEIGHT / 8;
			userText.height = Constants.SCREEN_HEIGHT / 8;
			passwordField.height = Constants.SCREEN_HEIGHT / 8;
			passwordText.height = Constants.SCREEN_HEIGHT / 8;
			emailField.height = Constants.SCREEN_HEIGHT / 8;
			emailText.height = Constants.SCREEN_HEIGHT / 8;
			
			userField.x = Constants.SCREEN_WIDTH / 3;
			passwordField.x = Constants.SCREEN_WIDTH / 3;
			emailField.x = Constants.SCREEN_WIDTH / 3;
			
			userField.y = 0;
			userText.y = 0;
			passwordField.y = Constants.SCREEN_HEIGHT / 5;
			passwordText.y = Constants.SCREEN_HEIGHT / 5;
			emailField.y = 2*Constants.SCREEN_HEIGHT / 5;
			emailText.y = 2*Constants.SCREEN_HEIGHT / 5;
			messageField.y = 3 * Constants.SCREEN_HEIGHT / 5;
			
			userField.restrict = "A-Za-z0-9";
			passwordField.restrict = "A-Za-z0-9";
			
			userText.text = "Username";
			passwordText.text = "Password";
			emailText.text = "Email";
			
			userText.textColor = 0xffffff;
			passwordText.textColor = 0xffffff;
			emailText.textColor = 0xffffff;
			messageField.textColor = 0xffffff;
			
			userField.maxChars = 15;
			passwordField.maxChars = 15;
			
			passwordField.displayAsPassword = true;
			
			addChild(userField);
			addChild(passwordField);
			addChild(messageField);
			addChild(emailField);
			addChild(userText);
			addChild(passwordText);
			addChild(emailText);
			
		}
		
		// authenticate user
		public function signup(userName:String, password:String, email:String):void {
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.userName = userName;
			urlVariables.password = password;
			urlVariables.email = email;
			
			var phpFileRequest:URLRequest = new URLRequest(SIGNUP_URL);
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
		 
		}
		
	}
}