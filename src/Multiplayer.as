package  
{
	import com.reyco1.multiuser.data.UserObject;
	import com.reyco1.multiuser.debug.Logger;
	import com.reyco1.multiuser.MultiUserSession;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import mx.core.FlexApplicationBootstrap;
	import unitstuff.Base;
	import unitstuff.Flock;
	import unitstuff.ResourcePoint;
	import unitstuff.Unit;
	import screens.PlayScreen;
	import screens.WaitingScreen;
	import screens.LoginScreen;
	import flash.net.*;
	
	public class Multiplayer 
	{
		private const SERVER		:String   = "rtmfp://p2p.rtmfp.net/";
		private const DEVKEY		:String   = "e4ece8a816e8d16dabef9b1a-cb286187d4bb"; // TODO: add your Cirrus key here. You can get a key from here : http://labs.adobe.com/technologies/cirrus/
		private const SERV_KEY		:String = SERVER + DEVKEY;
		
		private const OP_UNIT_SHOOT:String = "USH";
		private const OP_UNIT_DAMAGE:String = "UDA";
		private const OP_UNIT_DESTROY:String = "UDE";
		private const OP_UNIT_SPAWN:String = "USP";
		private const OP_UNIT_POSITION:String = "UP";
		
		private const OP_BASE_SHOOT:String = "BS";
		private const OP_BASE_DAMAGE:String = "BDA";
		private const OP_BASE_DESTROY:String = "BDE";
		
		private const OP_RESOURCE_CAPTURE:String = "ORC";
		
		private const OP_PLAYER_TAPPED:String = "PT";
		private const OP_MOVEMENT:String = "MO";
		private const OP_ALL_POSITIONS:String = "APO";
		
		public var mConnection		:MultiUserSession;
		private var mMyID:int;
		
		public var signals:SignalHandler;
		public var isConnected:Boolean;
		public var opponentIsConnected:Boolean;
		
		private var currentId:String;
		private var opponentId:String;

		private var currentUserName:String;
		private var opponentUserName:String;
		
		public function Multiplayer() {
			if (!PlayScreen.isMultiplayer) return;
			if (PlayScreen.isRanked) currentUserName = LoginScreen.myUsername;
			opponentIsConnected = false;
			initialize(); //T
			signals = new SignalHandler();
		}
		
		//establish connection
		protected function initialize():void {
			mConnection = new MultiUserSession(SERV_KEY, "multiuser/test/bo2" + WaitingScreen.roomId ); 		// create a new instance of MultiUserSession
			
			mConnection.onConnect 		= handleConnect;						// set the method to be executed when connected
			mConnection.onUserAdded 	= handleUserAdded;						// set the method to be executed once a user has connected
			mConnection.onUserRemoved 	= handleUserRemoved;					// set the method to be executed once a user has disconnected
			mConnection.onObjectRecieve = handleGetObject;						// set the method to be executed when we recieve data from a user
			
			var mMyName:String  = "User_" + Math.round(Math.random() * 100);
			if (PlayScreen.isRanked) mMyName = currentUserName;
			mConnection.connect(""+mMyName);

		}
		
		//maybe display waiting screen?
		protected function handleConnect(theUser:UserObject) :void {
			trace("I'm connected to game: " + theUser.name + ", total: " + mConnection.userCount); 
			currentId = theUser.id;
			isConnected = true;
		}
		
		//send a message saying that player X has joined, then start screen?
		protected function handleUserAdded(theUser:UserObject) :void {
			trace("FOUND USER");
			trace("User has joined the game: " + theUser.name + ", total: " + mConnection.userCount + ", " + theUser.id);
			opponentId = theUser.id;
			opponentIsConnected = true;
			opponentUserName = theUser.name;
			
			if (currentId < opponentId)
				PlayScreen.game.currentPlayer = 1;
			else
				PlayScreen.game.currentPlayer = 2;
			PlayScreen.game.start();
		}
		
		//stop the PlayScreen.game if a user disconnects?
		protected function handleUserRemoved(theUser:UserObject) :void {
			trace("User disconnected: " + theUser.name + ", total users: " + mConnection.userCount); 
			//test if the opponent disconnected
			if (theUser.id == opponentId && PlayScreen.game.gameOver == false) {
				PlayScreen.game.dispatchEventWith(NavEvent.GAME_OVER_WIN);
			}
		}
		
		public function sendUnitShoot(mUnit:Unit, mTarget:Unit):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_UNIT_SHOOT, unitId: mUnit.id, targetId: mTarget.id, 
				posX: mUnit.pos.x, posY: mUnit.pos.y, targetX: mTarget.pos.x, targetY: mTarget.pos.y } );
			}
		}
		
		public function sendUnitDestroy(unitId:int):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_UNIT_DESTROY, id: unitId } );
			}
		}
		
		//warning: what about moving unit before it spawns?
		public function sendUnitSpawn(mUnit:Unit):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_UNIT_SPAWN, type: mUnit.unitType, owner: mUnit.owner } );
			}
		}
		
		public function sendUnitPosition(mUnit:Unit):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_UNIT_POSITION, unit: mUnit } );
			}
		}

		public function sendMovement(units:String, goal:Point):void {
			if (PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_MOVEMENT, ids: units, x: goal.x, y: goal.y } );
			}
		}
		
		public function sendAllPositions(positions:String):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_ALL_POSITIONS, posString: positions } );
			}
		}
		
		public function sendResourceCapture(resourcePoint:ResourcePoint):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_RESOURCE_CAPTURE, id:resourcePoint.id, owner: resourcePoint.owner } );
			}
		}
		
		protected function handleGetObject(theUserId :String, theData :Object) :void {
			var aOpCode :String = theData.op;
			
			switch(aOpCode) {			
				case OP_UNIT_SHOOT:
					trace("UNIT SHOOTS");
					var unit:Unit = PlayScreen.game.dictionary[theData.unitId];
					var target:Unit = PlayScreen.game.dictionary[theData.targetId];
					if (!unit || !target) {
						break;
					}
					
					syncUnitPosition(theData.unitId, theData.posX, theData.posY);
					syncUnitPosition(theData.targetId, theData.targetX, theData.targetY);
					
					unit.target = target;
					unit.shoot();
					break;
				case OP_UNIT_DAMAGE:
					theData.unit.takeDamage(theData.damage);
					break;
				case OP_UNIT_DESTROY:
					trace("UNIT DIED!!!");
					signals.handleUnitDestroyed(theData.id);
					break;
				case OP_UNIT_SPAWN:
					trace("OPPONENT SPAWNING!!!");
					signals.handleSpawn(theData.type, theData.owner);
					break;
				case OP_MOVEMENT:
					trace("OPPONENT MOVED!!!");
					signals.handleMovement(theData.ids, new Point(theData.x, theData.y));
					break;
				case OP_ALL_POSITIONS:
					signals.handlePositions(theData.posString);
					break;
				case OP_RESOURCE_CAPTURE:
					signals.handleResourceCapture(theData.id, theData.owner);
					break;
			}
		}
		
		private function syncUnitPosition(unitId:int, posX:int, posY:int):void {
			var unit:Unit = PlayScreen.game.dictionary[unitId];
			unit.pos = new Point(posX, posY);
		}
		
		
		//Script to update the scores in a ranked match
		private static const UPDATE_URL:String = "http://samuelfc.mycpanel.princeton.edu/public_html/cos333/update_elo.php";
		
		public function updateElo():void {
			trace("updating the elo scores");
			
			var username:String = currentUserName; //the player who calls this is the winner, so username contains winner
			var opponent:String = opponentUserName;
			trace("winner: " + username + ", loser: " + opponent);
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.first = username;
			urlVariables.second = opponent;
			urlVariables.win = "1";
				
				
			var phpFileRequest:URLRequest = new URLRequest(UPDATE_URL);
			phpFileRequest.method = URLRequestMethod.POST;
			phpFileRequest.data = urlVariables;
			
			var phpLoader:URLLoader = new URLLoader();
			phpLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			//phpLoader.addEventListener(Event.COMPLETE, showResult);
			phpLoader.load(phpFileRequest);
		}
	}
}