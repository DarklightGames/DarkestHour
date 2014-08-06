class DH_VehicleFactoryAdvanced extends DH_VehicleFactory;

/*
To Do List:
//Ammo
//Smoke rounds for night variant
//Attachments (shrub camo)
//Have boolean to give message when the vehicle has been destroyed and output how many are left!
//Brain storm ideas


//Add bit to message a team whenever they lose a vehicle and give how many are left!
*/

struct WeaponSlotAmmoCharges
{
	var() int			WeaponSlotPosition;
	var() array<int>	AmmoCount;
};

//Variables
var()	bool				bNightMode; //Changes out the vehicle smoke if any to a night variant (not in use yet)
var()	bool				bUseSpeedAdjustments; //Boolean to determine to use the ModGearRatio override
var()	bool				bUseLostVehicleMessages; //Allows you to let a team know it lost a vehicle and how many are left
var()	bool				bInitiallyDeactivated; //Allows you to initially have the factory not active, must call it's activate function to activate
var()	bool				bUseTriggerToggle; //Allows events to toggle the factory on and off SHHHHWIINGGGG!
var()	bool				bInstantDestroyEmpty; //Allows you to instantly delete an empty LastSpawnedVehicle when using Trigger Toggle
var()	bool				bUseETAOnLostMessage; //Put a ETA on the end of the message when a vehicle is lost
//var		bool				bInitialized; //Used to

var()	string				TriggerActivationMessage; //Message to show when triggered
var()	string				CustomLostVehicleMessage; //String of the message ("We lost a SHORTVEHICLENAME!!! We have")
var()	string				CustomLostVehicleMessageEnd; //String of the message ("remaing. Lets use them wisely.")

var()	name				EventOnDepletion; //Will call this tag when the factory is depleted!

var()   InterpCurve		    ModTorqueCurve; // Engine output torque
var()	float				ModTransRatio; //Allows you to overwrite the vehicle's transratio
var()	float				ModSteerSpeed; //Modified turnspeed value
var()	float				ModMaxCriticalSpeed; //Modified max critical speed
var()	float				ModEngineInertia; //
var()	float				ModGearRatios[5]; //Modified gear ratios (0 is reverse, 1-4 are forward)

//Ammo Variables
var()	array<WeaponSlotAmmoCharges>	ModWeaponSlotAmmoCount;


//Functions

// Uses a trigger, you can now call this factory to toggle it if set
event Trigger( Actor Other, Pawn EventInstigator )
{
	local Controller		C;
	local PlayerController	P;

	if( bUseTriggerToggle )
	{
		if( !bFactoryActive )
		{
			Activate(TeamNum);

			if( TriggerActivationMessage != "" )
			{
				//Lets send the message to the appropriate players
				if( TeamNum == NEUTRAL )
				{
					Level.Game.Broadcast(self, TriggerActivationMessage, 'Event');
				}
				else
				{
					for(C=Level.ControllerList;C!=None;C=C.NextController)
					{
						P = PlayerController(C);
						if (P != None && P.GetTeamNum() == TeamNum)
							P.TeamMessage(C.PlayerReplicationInfo, TriggerActivationMessage, 'Event');
					}
				}
			}
		}
		else if( bInstantDestroyEmpty && LastSpawnedVehicle != None && ROVehicle(LastSpawnedVehicle).IsVehicleEmpty() )
		{
			Deactivate();
			ROVehicle(LastSpawnedVehicle).Destroy();
		}
		else
			Deactivate();
	}
}

event VehicleDestroyed(Vehicle V)
{
	local int NumVehiclesRemaining;
	local string FinalMessageString;
	local Controller		C;
	local PlayerController	P;

	super.VehicleDestroyed(V);

	//NumVehiclesRemaining = VehicleRespawnLimit - TotalSpawnedVehicles;
	//Level.Game.Broadcast(self, "Lost a vehicle! This is how many is left: "$NumVehiclesRemaining);

	//Lets see if the factory has spawned a vehicle
	//I could setup an event to call from here for custom gameplay and vehicle objectives
	//This will stop messages from appearing on round reset (or beginning of round)

	//Make sure there is atleast 5 seconds into the round before sending messages, or else ROTeamGame, Play state will call it when reseting things
	if( bUseLostVehicleMessages && (ROTeamGame(Level.Game).ElapsedTime - ROTeamGame(Level.Game).RoundStartTime) > 5 )
	{
		NumVehiclesRemaining = VehicleRespawnLimit - TotalSpawnedVehicles;

		//Build custom message if needed
		if( CustomLostVehicleMessage != "" && CustomLostVehicleMessageEnd != "" )
		{
			FinalMessageString = CustomLostVehicleMessage @ NumVehiclesRemaining @ CustomLostVehicleMessageEnd;
			if( bUseETAOnLostMessage && NumVehiclesRemaining != 0 )
   				FinalMessageString $= " ETA" @ int(RespawnTime) @ "seconds.";
		}
		else //Use preconstructed message
		{
			FinalMessageString = LastSpawnedVehicle.VehicleNameString @ "has been destroyed." @ NumVehiclesRemaining @ "remaining.";
			if( bUseETAOnLostMessage && NumVehiclesRemaining != 0 )
   				FinalMessageString $= " ETA" @ int(RespawnTime) @ "seconds.";
		}

		//Lets send the message to the appropriate players
		if( TeamNum == NEUTRAL )
		{
			Level.Game.Broadcast(self, FinalMessageString, 'Event');
		}
		else
		{
			for(C=Level.ControllerList;C!=None;C=C.NextController)
			{
				P = PlayerController(C);
				if (P != None && P.GetTeamNum() == TeamNum)
					P.TeamMessage(C.PlayerReplicationInfo, FinalMessageString, 'Event');
			}
		}

		//Call Important Event
		if( EventOnDepletion != '' && NumVehiclesRemaining == 0 )
		{
			//Level.Game.Broadcast(self, "Factory Depleted, Event Called if Set: "$EventOnDepletion);
			TriggerEvent(EventOnDepletion, self, none); //Triggers the event EventOnDepletion
		}

		//Debug
  		//Level.Game.Broadcast(self, "Lost a vehicle! This is how many is left: "$NumVehiclesRemaining);
	}
}


//modified function to set the spawned vehicle with a custom tag/event (called by the teleporter)???????????????? DOES THIS WORK!????
//should I also give the vehicle a tag or event?
//what else should I have?
function SpawnVehicle()
{
	local int i;

	//Call the super
	super.SpawnVehicle();

	if( LastSpawnedVehicle != none  )
	{
		//Set Ammo Amounts for WeaponPawns
		//ROVehicle(LastSpawnedVehicle).WeaponPawns[].Gun.MainAmmoCharge[] = NUM;

		//Sets speed adjustments
		if( bUseSpeedAdjustments )
		{
			if( ModEngineInertia != 0 )
				ROWheeledVehicle(LastSpawnedVehicle).EngineInertia = ModEngineInertia;

			if( ModTransRatio != 0 )
				ROWheeledVehicle(LastSpawnedVehicle).TransRatio = ModTransRatio;

			if( ModSteerSpeed != 0 )
				ROWheeledVehicle(LastSpawnedVehicle).SteerSpeed = ModSteerSpeed;

			if( ModTorqueCurve.Points.Length != 0 )
			    ROWheeledVehicle(LastSpawnedVehicle).TorqueCurve = ModTorqueCurve;

			//Set Gears
			for(i = 0; i < ArrayCount(ModGearRatios); ++i)
			{
				if(ModGearRatios[i] != 0)
					ROWheeledVehicle(LastSpawnedVehicle).GearRatios[i] = ModGearRatios[i];
			}

			//Set MaxCriticalSpeed (it exists in two classes for vehicle hierarchies)
			if( ModMaxCriticalSpeed != 0 )
			{
				DH_ROTransportCraft(LastSpawnedVehicle).MaxCriticalSpeed = ModMaxCriticalSpeed;
				DH_ROTreadCraft(LastSpawnedVehicle).MaxCriticalSpeed = ModMaxCriticalSpeed;
			}
		}

		//Debug
		//Level.Game.Broadcast(self, "SpawnedVehicle", 'Say');
		//Level.Game.Broadcast(self, "ClassDefaultSteerSpeed: "$ROWheeledVehicle(VehicleClass).default.SteerSpeed, 'Say');
		//Level.Game.Broadcast(self, "Steerspeed: "$ROWheeledVehicle(LastSpawnedVehicle).SteerSpeed, 'Say');
	}
}

//Override to allow for initial deactivation
//how it worked before:
//basically at round in play start, it'll reset all the factories by calling each's reset function
//if it doesn't use spawn areas it'll automatically activate (no matter what)
//if it uses spawn areas, ROTeamGame will run a function to determine which factories should be activated based on activate spawn areas
//Now you can bypass the entire bUsesSpawnAreas bullshit, but it keeps the same functionality otherwise
simulated function Reset()
{
	 //log("Reset got called for "$self);
	 if( bInitiallyDeactivated && !bUsesSpawnAreas )
	 {
	 	 TotalSpawnedVehicles=0;
		 bFactoryActive=false;
	 }
	 else if( !bUsesSpawnAreas )
	 {
		 //log(self$" spawning vehicle because of reset");
		 SpawnVehicle();
		 TotalSpawnedVehicles=0;
		 Activate(TeamNum);
	 }
	 else
	 {
		 TotalSpawnedVehicles=0;
		 bFactoryActive=false;
	 }
}

defaultproperties
{
	bUseLostVehicleMessages=True
	RespawnTime=15.000000
	bFactoryActive=True
	VehicleClass=Class'DH_Vehicles.DH_ShermanTank'
	Mesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_extA'
}