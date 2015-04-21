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
		private var messageField:TextField;
		
		public function SignupScreen() {
			super();
		
			messageField = new TextField();
			userField = new TextField();
			passwordField = new TextField();
			emailField = new TextField();
			userText = new TextField();
			passwordText = new TextField();
			emailField = new TextField();
			userText.defaultTextFormat = textFormat;
			passwordText.defaultTextFormat = textFormat;
			
			var textFormat:TextFormat = new TextFormat("Arial", 24, 0x000000);
			textFormat.align = TextFormatAlign.LEFT;
			
			userField.defaultTextFormat = textFormat;
			passwordField.defaultTextFormat = textFormat;
			messageField.defaultTextFormat = textFormat;
			emailField.defaultTextFormat = textFormat;
			
			userField.type = TextFieldType.INPUT;
			passwordField.type = TextFieldType.INPUT;
			emailField.type = TextFieldType.INPUT;
			
			
			messageField.text = "testing";
			messageField.width = 300;
			
			userField.y = 0;
			passwordField.y = 100;
			emailField.y = 200;
			messageField.y = 250;
			
			userField.restrict = "A-Za-z0-9";
			passwordField.restrict = "A-Za-z0-9";
			
			userField.maxChars = 15;
			passwordField.maxChars = 15;
			
			passwordField.displayAsPassword = true;
			
			addChild(userField);
			addChild(passwordField);
			addChild(messageField);
			addChild(emailField);
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