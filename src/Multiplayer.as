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
		
		private const OP_FLOCK_SET_GOAL:String = "FSG";
		private const OP_FLOCK_SPLIT:String = "FS";
		private const OP_FLOCK_MERGE:String = "FM";
		private const OP_FLOCK_DESTROY:String = "FD";
		
		private const OP_PLAYER_TAPPED:String = "PT"
		
		private var mConnection		:MultiUserSession;
		private var mMyID:int;
		
		//necessary for reco1
		public function Multiplayer() {
			Logger.LEVEL = Logger.ALL;
			initialize(); //T
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
			mConnection = new MultiUserSession(SERV_KEY, "multiuser/test"); 		// create a new instance of MultiUserSession
			
			mConnection.onConnect 		= handleConnect;						// set the method to be executed when connected
			mConnection.onUserAdded 	= handleUserAdded;						// set the method to be executed once a user has connected
			mConnection.onUserRemoved 	= handleUserRemoved;					// set the method to be executed once a user has disconnected
			mConnection.onObjectRecieve = handleGetObject;						// set the method to be executed when we recieve data from a user
			
			var mMyName:int  = mConnection.userCount;
			mConnection.connect(""+mMyName);
			
			//need some kind of loading/waiting screen?
			//(FlxG.state as PlayState).hud.showMessage("Connecting", DEVKEY.length == 0 ? "ATTENTION! Use a valid key in DEVKEY at Multiplayer.as (line 38)" : "Please wait while we join the fun!", Number.MAX_VALUE);
		}
		
		//maybe display waiting screen?
		protected function handleConnect(theUser:UserObject) :void {
			trace("I'm connected: " + theUser.name + ", total: " + mConnection.userCount); 
		}
		
		//send a message saying that player X has joined, then start screen?
		protected function handleUserAdded(theUser:UserObject) :void {
			trace("FOUND USER");
			trace("User has joined: " + theUser.name + ", total: " + mConnection.userCount);
		}
		
		//stop the game if a user disconnects?
		protected function handleUserRemoved(theUser:UserObject) :void {
			trace("User disconnected: " + theUser.name + ", total users: " + mConnection.userCount); 
		}
		
		//move the flock to the goal
		public function sendFlockSetGoal(mFlock:Flock, mGoal:Point):void {
			mConnection.sendObject( { op: OP_FLOCK_SET_GOAL, flock: mFlock, goal: mGoal } );
		}
		
		//replace flock0 with the two flocks: flock1, flock2
		public function sendFlockSplit(mFlock0:Flock, mFlock1:Flock, mFlock2:Flock):void {
			mConnection.sendObject( { op: OP_FLOCK_SPLIT, flock0: mFlock0, flock1: mFlock1, flock2: mFlock2 } );
		}
		
		//merge two flocks
		public function sendFlockMerge(mFlock1:Flock, mFlock2:Flock):void {
			mConnection.sendObject( { op: OP_FLOCK_MERGE, flock1: mFlock1, flock2: mFlock2 } );
		}
		
		//remove a flock
		public function sendFlockDestroy(mFlock:Flock):void {
			mConnection.sendObject( { op: OP_FLOCK_DESTROY, flock: mFlock } );
		}
		
		public function sendBaseShoot(mBase:Base, mTarget:Unit):void {
			mConnection.sendObject( { op: OP_BASE_SHOOT, base: mBase, target: mTarget} );
		}
		
		public function sendBaseDamage(mBase:Base, dmg:int):void {
			mConnection.sendObject( { op: OP_BASE_DAMAGE, damage: dmg } );
		}
		
		public function sendBaseDestroy(mBase:Base):void {
			mConnection.sendObject( { op: OP_BASE_DESTROY } );
		}
		
		public function sendUnitShoot(mUnit:Unit, mTarget:Unit):void {
			mConnection.sendObject( { op: OP_UNIT_SHOOT, unit: mUnit, target: mTarget } );
		}
		
		public function sendUnitDamage(mUnit:Unit, dmg:int):void {
			mConnection.sendObject( { op: OP_UNIT_DAMAGE, unit: mUnit, damage: dmg } );
		}
		
		public function sendUnitDestroy(mUnit:Unit):void {
			mConnection.sendObject( { op: OP_UNIT_DESTROY, unit: mUnit } );
		}
		
		public function sendUnitSpawn(mUnit:Unit):void {
			mConnection.sendObject( { op: OP_UNIT_SPAWN, unit: mUnit } );
		}
		
		public function sendUnitPosition(mUnit:Unit):void {
			mConnection.sendObject( { op: OP_UNIT_POSITION, unit: mUnit } );
		}
		
		public function sendPlayerTapped(startTap:Point, endTap:Point):void {
			mConnection.sendObject( { op: OP_PLAYER_TAPPED , startX: startTap.x, startY: startTap.y, endX: endTap.x, endY: endTap.y } );
		}
		
		/*
		public function sendPosition(theShip :Ship) :void	{
			mConnection.sendObject({op: OP_POSITION, x: theShip.x, y: theShip.y, angle: theShip.angle});
		}
		
		public function sendShot(theShip :Ship, theBulletType :Class) :void	{
			mConnection.sendObject({op: OP_SHOT, x: theShip.x, y: theShip.y, dx: theShip.direction.x, dy: theShip.direction.y, b: convertBulletClassToString(theBulletType)});
		}
		
		public function sendDie(theShip :Ship) :void	{
			mConnection.sendObject({op: OP_DIE, x: theShip.x, y: theShip.y});
		}
		*/
		protected function handleGetObject(theUserId :String, theData :Object) :void {
			var aOpCode :String = theData.op;
			
			switch(aOpCode) {
				/*
				case OP_POSITION:
					syncPosition(theUserId, theData);
					break;
					
				case OP_SHOT:
					syncPosition(theUserId, theData);
					mShips[theUserId].direction.x = theData.dx;
					mShips[theUserId].direction.y = theData.dy;

					(FlxG.state as PlayState).shoot(mShips[theUserId], convertBulletStringToClass(theData.b));
					break;
					
				case OP_DIE:
					mShips[theUserId].kill();
					break;
				*/
				case OP_FLOCK_SET_GOAL:
					theData.flock = theData.goal;
					break;
					
				case OP_FLOCK_SPLIT:
					
					break;
				case OP_FLOCK_MERGE:
					
					break;
				case OP_FLOCK_DESTROY:
					
					break;
					
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
					theData.unit.target = theData.target;
					theData.unit.shoot();
					break;
				case OP_UNIT_DAMAGE:
					theData.unit.takeDamage(theData.damage);
					break;
				case OP_UNIT_DESTROY:
					//PlayScreen.game.removeUnit(theData.unit);
					break;
				case OP_UNIT_SPAWN:
					//PlayScreen.game.spawn(theData.unit.unitType, theData.unit.pos, theData.unit.owner);
					break;
				case OP_PLAYER_TAPPED:
					trace("The player just tapped something!");
					PlayScreen.game.handleTap(theData.startX, theData.startY, theData.endX, theData.endY);
					
					break;
			}
		}
		/*
		private function syncPosition(theUserId :String, theData :Object) :void {
			mShips[theUserId].x  = theData.x;
			mShips[theUserId].y  = theData.y;
			
			if(theData.angle) {
				mShips[theUserId].angle = theData.angle;
			}
		}
		*/
	}
}