package  
{
	import com.reyco1.multiuser.data.UserObject;
	import com.reyco1.multiuser.debug.Logger;
	import com.reyco1.multiuser.MultiUserSession;
	import flash.geom.Point;
	import mx.core.FlexApplicationBootstrap;
	import unitstuff.Base;
	import unitstuff.Flock;
	import unitstuff.Unit;
	import screens.PlayScreen;
	import screens.WaitingScreen;
	
	public class WaitingRoom
	{
		private const SERVER		:String   = "rtmfp://p2p.rtmfp.net/";
		private const DEVKEY		:String   = "e4ece8a816e8d16dabef9b1a-cb286187d4bb"; // TODO: add your Cirrus key here. You can get a key from here : http://labs.adobe.com/technologies/cirrus/
		private const SERV_KEY		:String = SERVER + DEVKEY;
		
		public var mConnection		:MultiUserSession;
		private var mMyID:int;
		public var foundPlayer:Boolean;
		
		public var isConnected:Boolean;
		public var screen:WaitingScreen;
		
		//necessary for reco1
		public function WaitingRoom(ws:WaitingScreen) {
			//Logger.LEVEL = Logger.ALL;
			initialize(); //T
			this.screen = ws;
		}
		
		//establish connection
		protected function initialize():void {
			foundPlayer = false;
			mConnection = new MultiUserSession(SERV_KEY, "multiuser/test/waitingroom"); 		// create a new instance of MultiUserSession
			
			mConnection.onConnect 		= handleConnect;						// set the method to be executed when connected
			mConnection.onUserAdded 	= handleUserAdded;						// set the method to be executed once a user has connected
			mConnection.onUserRemoved 	= handleUserRemoved;					// set the method to be executed once a user has disconnected
			mConnection.onObjectRecieve = handleGetObject;						// set the method to be executed when we recieve data from a user
			
			var mMyName:String  = "User_" + Math.round(Math.random()*100);
			mConnection.connect(""+mMyName);

			//need some kind of loading/waiting screen?
			
			}
		
		//enter as the second player, then you know opponent is there
		protected function handleConnect(theUser:UserObject) :void {
			//trace("I'm waiting: " + theUser.name + ", total: " + mConnection.userCount); 
			isConnected = true;
			//mConnection.close()
			//screen.onMatchFound();
			/*
			if (mConnection.userCount == 2) {
				foundPlayer = true;
				if(isConnected)
					mConnection.close();
				screen.onMatchFound();
			}
			*/
		}
		
		//called when 2nd player joins
		protected function handleUserAdded(theUser:UserObject) :void {
			trace("FOUND USER");
			//trace("User has joined: " + theUser.name + ", total: " + mConnection.userCount + ", " + theUser.id);
			/*
			if(isConnected)
				mConnection.close();
			foundPlayer = true;
			screen.onatchFound();
			*/
			
			//mConnection.close();
		}
		
		//stop the game if a user disconnects?
		protected function handleUserRemoved(theUser:UserObject) :void {
			//trace("User disconnected: " + theUser.name + ", total users: " + mConnection.userCount); 
		}

		protected function handleGetObject(theUserId :String, theData :Object) :void {
			var aOpCode :String = theData.op;
			
			switch(aOpCode) {			
				
			}
		}
	}
}