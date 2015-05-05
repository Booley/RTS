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
		private const DEVKEY		:String   = "d5f3e28c7ec7157b10a77250-ebc94833328b"; // TODO: add your Cirrus key here. You can get a key from here : http://labs.adobe.com/technologies/cirrus/
		private const SERV_KEY		:String = SERVER + DEVKEY;
		
		public var mConnection		:MultiUserSession;
		private var mMyID:int;
		public var foundPlayer:Boolean;
		
		public var isConnected:Boolean;
		public var screen:WaitingScreen;
		public var isWaiting:Boolean;
		private var currentId:String;
		//necessary for reco1
		public function WaitingRoom(ws:WaitingScreen) {
			//Logger.LEVEL = Logger.ALL;
			initialize(); //T
			this.screen = ws;
		}
		
		//establish connection
		protected function initialize():void {
			foundPlayer = false;
			isWaiting = true;
			mConnection = new MultiUserSession(SERV_KEY, "multiuser/test/waitingroom/bo2"); 		// create a new instance of MultiUserSession
			
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
			trace("I'm waiting: " + theUser.name + ", total: " + mConnection.userCount); 
			isConnected = true;
			currentId = theUser.id;
		}
		
		//called when 2nd player joins
		protected function handleUserAdded(theUser:UserObject) :void {
			trace("FOUND USER in waiting room");
			trace("User has joined waiting room: " + theUser.name + ", total: " + mConnection.userCount + ", " + theUser.id);
			if (!isWaiting) return;
			isWaiting = false;
			//mConnection.close();
			
			//create a room id
			var room:String = "";
			var opponentId:String = theUser.id;
			
			if (currentId < opponentId)
				room = currentId + opponentId;
			else
				room = opponentId + currentId;
			
			screen.onMatchFound(room);
			
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