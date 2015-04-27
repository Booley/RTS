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
		
		private const OP_PLAYER_TAPPED:String = "PT";
		private const OP_MOVEMENT:String = "MO";
		private const OP_ALL_POSITIONS:String = "APO";
		
		private var mConnection		:MultiUserSession;
		private var mMyID:int;
		
		public var game:Game;
		public var signals:SignalHandler;
		public var isConnected:Boolean;
		
		//necessary for reco1
		public function Multiplayer() {
			Logger.LEVEL = Logger.ALL;
			initialize(); //T
			signals = new SignalHandler();
		}
		
		/*
		//the tick?
		public function update() :void {
			var aPlayer :Ship = (FlxG.state as PlayState).player;
			
			// TODO: lower the sending interval so Flash won't die :)
			if (aPlayer != null) {
				sendPosition((FlxG.state as PlayState).player);
			}
		}
		*/
		
		//???
		//private function isPlayerControlled(theShip :Ship) :Boolean {
			//return theShip == null || theShip.owner == (FlxG.state as PlayState).player.owner;
		//}
		
		//establish connection
		protected function initialize():void {
			mConnection = new MultiUserSession(SERV_KEY, "multiuser/test/BO"); 		// create a new instance of MultiUserSession
			
			mConnection.onConnect 		= handleConnect;						// set the method to be executed when connected
			mConnection.onUserAdded 	= handleUserAdded;						// set the method to be executed once a user has connected
			mConnection.onUserRemoved 	= handleUserRemoved;					// set the method to be executed once a user has disconnected
			mConnection.onObjectRecieve = handleGetObject;						// set the method to be executed when we recieve data from a user
			
			var mMyName:String  = "User_" + Math.round(Math.random()*100);
			mConnection.connect(""+mMyName);
			
			//need some kind of loading/waiting screen?
			//(FlxG.state as PlayState).hud.showMessage("Connecting", DEVKEY.length == 0 ? "ATTENTION! Use a valid key in DEVKEY at Multiplayer.as (line 38)" : "Please wait while we join the fun!", Number.MAX_VALUE);
		}
		
		//maybe display waiting screen?
		protected function handleConnect(theUser:UserObject) :void {
			trace("I'm connected: " + theUser.name + ", total: " + mConnection.userCount); 
			isConnected = true;
			game.currentPlayer = mConnection.userCount;
			trace(game.currentPlayer);
		}
		
		//send a message saying that player X has joined, then start screen?
		protected function handleUserAdded(theUser:UserObject) :void {
			trace("FOUND USER");
			trace("User has joined: " + theUser.name + ", total: " + mConnection.userCount + ", " + theUser.id);
		}
		
		//stop the game if a user disconnects?
		protected function handleUserRemoved(theUser:UserObject) :void {
			trace("User disconnected: " + theUser.name + ", total users: " + mConnection.userCount); 
		}
		
		public function update():void {
			
			
		}
		
		public function sendBaseShoot(mBase:Base, mTarget:Unit):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_BASE_SHOOT, base: mBase, target: mTarget } );
			}
		}
		
		public function sendBaseDamage(mBase:Base, dmg:int):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_BASE_DAMAGE, damage: dmg } );
			}
		}
		
		public function sendBaseDestroy(mBase:Base):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_BASE_DESTROY } );
			}
		}
		
		public function sendUnitShoot(mUnit:Unit, mTarget:Unit):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_UNIT_SHOOT, unitId: mUnit.id, targetId: mTarget.id, 
				posX: mUnit.pos.x, posY: mUnit.pos.y, targetX: mTarget.pos.x, targetY: mTarget.pos.y } );
			}
		}
		
		public function sendUnitDamage(mUnit:Unit, dmg:int):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_UNIT_DAMAGE, unit: mUnit, damage: dmg } );
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
		
		public function sendPlayerTapped(startTap:Point, endTap:Point):void {
			mConnection.sendObject( { op: OP_PLAYER_TAPPED , startX: startTap.x, startY: startTap.y, endX: endTap.x, endY: endTap.y } );
		}
		
		public function sendMovement(units:String, goal:Point):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_MOVEMENT, ids: units, x: goal.x, y: goal.y } );
			}
		}
		
		public function sendAllPositions(positions:String):void {
			if(PlayScreen.isMultiplayer) {
				mConnection.sendObject( { op: OP_ALL_POSITIONS, posString: positions } );
			}
		}
		
		protected function handleGetObject(theUserId :String, theData :Object) :void {
			var aOpCode :String = theData.op;
			
			switch(aOpCode) {			
				case OP_BASE_SHOOT:
					theData.base.target = theData.target;
					theData.base.shoot(); //don't worry about cooldown, that's not a state represented by the other player
					break;
				
				case OP_BASE_DAMAGE:
					theData.base.takeDamage(theData.damage);
					break;
				case OP_BASE_DESTROY:
					
					break;
				case OP_UNIT_SHOOT:
					trace("UNIT SHOOTS");
					var unit:Unit = game.dictionary[theData.unitId];
					var target:Unit = game.dictionary[theData.targetId];
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
					signals.handleSpawn(theData.type, theData.owner);
					//PlayScreen.game.spawn(theData.unit.unitType, theData.unit.pos, theData.unit.owner);
					break;
				case OP_MOVEMENT:
					trace("OPPONENT MOVED!!!");
					signals.handleMovement(theData.ids, new Point(theData.x, theData.y));
					break;
				case OP_ALL_POSITIONS:
					signals.handlePositions(theData.posString);
					break;
			}
		}
		
		private function syncUnitPosition(unitId:int, posX:int, posY:int):void {
			var unit:Unit = PlayScreen.game.dictionary[unitId];
			unit.pos = new Point(posX, posY);
		}
	}
}