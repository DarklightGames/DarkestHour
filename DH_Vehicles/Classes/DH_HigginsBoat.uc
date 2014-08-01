//==============================================================================
// DH_HigginsBoat
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Allied landing craft
//==============================================================================
class DH_HigginsBoat extends DH_BoatVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_HigginsBoat_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx

var     	sound       		RampDownSound;
var     	sound       		RampUpSound;
var     	float       		RampSoundVolume;

var	name			RampDownIdleAnim;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat');

	Super.UpdatePrecacheMaterials();
}

// Overriden because the animation needs to play on the server for this vehicle for the commanders hit detection
function ServerChangeViewPoint(bool bForward)
{
	if (bForward)
	{
		if (DriverPositionIndex < (DriverPositions.Length - 1))
		{
			PreviousPositionIndex = DriverPositionIndex;
			DriverPositionIndex++;

			if (Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
			{
				NextViewPoint();
			}

			if (Level.NetMode == NM_DedicatedServer)
			{
				GoToState('ViewTransition');
			}
		}
     }
     else
     {
		if (DriverPositionIndex > 0)
		{
			PreviousPositionIndex = DriverPositionIndex;
			DriverPositionIndex--;

			if (Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer)
			{
				NextViewPoint();
			}

			if (Level.NetMode == NM_DedicatedServer)
			{
				GoToState('ViewTransition');
			}

		}
     }
}

//Overwritten to add Higgins Boat ramp sounds
simulated state ViewTransition
{
	simulated function HandleTransition()
	{
	     	if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer)
	     	{
	         		if (DriverPositions[DriverPositionIndex].PositionMesh != none && !bDontUsePositionMesh)
	             			LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
	     	}

		 if (PreviousPositionIndex < DriverPositionIndex && HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
		 {
		 	 //log("HandleTransition Player Transition Up!");
			 PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
			 //ADDED RAMP UP sound HERE
			 PlayOwnedSound(RampUpSound, SLOT_Misc, RampSoundVolume/255.0,, 150, , false);
		 }
		 else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
		 {
		 	 //log("HandleTransition Player Transition Down!");
			 PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
			 //ADDED RAMP DOWN sound HERE
			 PlayOwnedSound(RampDownSound, SLOT_Misc, RampSoundVolume/255.0,, 150, , false);
		}

	     if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim))
	         	Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
	}

	simulated function AnimEnd(int channel)
	{
		GotoState('');
	}

	simulated function EndState()
	{
		if (PlayerController(Controller) != none)
		{
			PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
			PlayerController(Controller).SetRotation(rot(0, 0, 0));
		}
	}

	Begin:
	HandleTransition();
	Sleep(0.2);
}

// overwritten for ramp
function bool KDriverLeave(bool bForceLeave)
{
	local bool bSuperDriverLeave;

	InitialPositionIndex=DriverPositionIndex;
	PreviousPositionIndex=InitialPositionIndex;

	bSuperDriverLeave = super.KDriverLeave(bForceLeave);

    DriverLeft();
	MaybeDestroyVehicle();
	return bSuperDriverLeave;
}

simulated function ClientKDriverEnter(PlayerController PC)
{
	super.ClientKDriverEnter(PC);

	//Higgins boat hint.  A long time coming.
	DHPlayer(PC).QueueHint(42, true);
}

// overwritten for ramp
function DriverDied()
{
	InitialPositionIndex=DriverPositionIndex;
	super.DriverDied();
	DriverLeft();
	MaybeDestroyVehicle();
}


// Called by notifies!!
function RampUpIdle()
{
	LoopAnim(BeginningIdleAnim);
	DestAnimName=BeginningIdleAnim;
}

function RampDownIdle()
{
	LoopAnim(RampDownIdleAnim);
	DestAnimName=RampDownIdleAnim;
}

// Overridden from Vehicle.uc to prevent being spawned outside the boat while moving
function bool PlaceExitingDriver()
{
	local int		i, j;
	local vector	tryPlace, Extent, HitLocation, HitNormal, ZOffset, RandomSphereLoc;
	local float BestDir, NewDir;

	if (Driver == none)
		return false;
	Extent = Driver.default.CollisionRadius * vect(1,1,0);
	Extent.Z = Driver.default.CollisionHeight;
	ZOffset = Driver.default.CollisionHeight * vect(0,0,1);

/*	//avoid running driver over by placing in direction perpendicular to velocity
	if (VSize(Velocity) > 100)
	{
		tryPlace = Normal(Velocity cross vect(0,0,1)) * (CollisionRadius + Driver.default.CollisionRadius) * 1.25 ;
		if ((Controller != none) && (Controller.DirectionHint != vect(0,0,0)))
		{
			if ((tryPlace dot Controller.DirectionHint) < 0)
				tryPlace *= -1;
		}
		else if (FRand() < 0.5)
				tryPlace *= -1; //randomly prefer other side
		if ((Trace(HitLocation, HitNormal, Location + tryPlace + ZOffset, Location + ZOffset, false, Extent) == none && Driver.SetLocation(Location + tryPlace + ZOffset))
		     || (Trace(HitLocation, HitNormal, Location - tryPlace + ZOffset, Location + ZOffset, false, Extent) == none && Driver.SetLocation(Location - tryPlace + ZOffset)))
			return true;
	}
*/
	if ((Controller != none) && (Controller.DirectionHint != vect(0,0,0)))
	{
		// first try best position
		tryPlace = Location;
		BestDir = 0;
		for(i=0; i<ExitPositions.Length; i++)
		{
			NewDir = Normal(ExitPositions[i] - Location) Dot Controller.DirectionHint;
			if (NewDir > BestDir)
			{
				BestDir = NewDir;
				tryPlace = ExitPositions[i];
			}
		}
		Controller.DirectionHint = vect(0,0,0);
		if (tryPlace != Location)
		{
			if (bRelativeExitPos)
			{
				if (ExitPositions[0].Z != 0)
					ZOffset = vect(0,0,1) * ExitPositions[0].Z;
				else
					ZOffset = Driver.default.CollisionHeight * vect(0,0,2);

				tryPlace = Location + ((tryPlace-ZOffset) >> Rotation) + ZOffset;

				// First, do a line check (stops us passing through things on exit).
				if ((Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) == none)
					&& Driver.SetLocation(tryPlace))
					return true;
			}
			else if (Driver.SetLocation(tryPlace))
				return true;
		}
	}

	if (!bRelativeExitPos)
	{
		for(i=0; i<ExitPositions.Length; i++)
		{
			tryPlace = ExitPositions[i];

			if (Driver.SetLocation(tryPlace))
				return true;
			else
			{
				for (j=0; j<10; j++) // try random positions in a sphere...
				{
					RandomSphereLoc = VRand()*200* FMax(FRand(),0.5);
					RandomSphereLoc.Z = Extent.Z * FRand();

					// First, do a line check (stops us passing through things on exit).
					if (Trace(HitLocation, HitNormal, tryPlace+RandomSphereLoc, tryPlace, false, Extent) == none)
					{
						if (Driver.SetLocation(tryPlace+RandomSphereLoc))
							return true;
					}
					else if (Driver.SetLocation(HitLocation))
						return true;
				}
			}
		}
		return false;
	}

	for(i=0; i<ExitPositions.Length; i++)
	{
		if (ExitPositions[0].Z != 0)
			ZOffset = vect(0,0,1) * ExitPositions[0].Z;
		else
			ZOffset = Driver.default.CollisionHeight * vect(0,0,2);

		tryPlace = Location + ((ExitPositions[i]-ZOffset) >> Rotation) + ZOffset;

		// First, do a line check (stops us passing through things on exit).
		if (Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != none)
			continue;

		// Then see if we can place the player there.
		if (!Driver.SetLocation(tryPlace))
			continue;

		return true;
	}
	return false;
}

event RanInto(Actor Other)
{
     return;
}

function bool EncroachingOn(Actor Other)
{
     return false;
}

defaultproperties
{
     RampDownSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsRampClose01'
     RampUpSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsRampOpen01'
     RampSoundVolume=180.000000
     RampDownIdleAnim="Ramp_Idle"
     DriverCameraBoneName="Camera_driver"
     WashSound=Sound'DH_AlliedVehicleSounds.higgins.wash01'
     WashSoundBoneL="Wash_L"
     WashSoundBoneR="Wash_R"
     EngineSound=SoundGroup'DH_AlliedVehicleSounds.higgins.HigginsEngine_loop'
     EngineSoundBone="Engine"
     MaxPitchSpeed=150.000000
     DestAnimName="Higgins-Idle"
     DestAnimRate=1.000000
     WheelSoftness=0.025000
     WheelPenScale=1.200000
     WheelPenOffset=0.010000
     WheelRestitution=0.100000
     WheelInertia=0.100000
     WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
     WheelLongSlip=0.001000
     WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
     WheelLongFrictionScale=1.100000
     WheelLatFrictionScale=1.550000
     WheelHandbrakeSlip=0.010000
     WheelHandbrakeFriction=0.100000
     WheelSuspensionTravel=10.000000
     WheelSuspensionMaxRenderTravel=5.000000
     FTScale=0.030000
     ChassisTorqueScale=0.095000
     MinBrakeFriction=4.000000
     MaxSteerAngleCurve=(Points=((OutVal=45.000000),(InVal=300.000000,OutVal=30.000000),(InVal=500.000000,OutVal=20.000000),(InVal=600.000000,OutVal=15.000000),(InVal=1000000000.000000,OutVal=10.000000)))
     TorqueCurve=(Points=((OutVal=1.000000),(InVal=200.000000,OutVal=0.750000),(InVal=1500.000000,OutVal=2.000000),(InVal=2200.000000)))
     GearRatios(0)=-0.200000
     GearRatios(1)=0.200000
     GearRatios(2)=0.350000
     GearRatios(3)=0.500000
     GearRatios(4)=0.630000
     TransRatio=0.090000
     LSDFactor=1.000000
     EngineBrakeFactor=0.000100
     EngineBrakeRPMScale=0.100000
     MaxBrakeTorque=20.000000
     SteerSpeed=20.000000
     TurnDamping=50.000000
     StopThreshold=100.000000
     HandbrakeThresh=200.000000
     EngineInertia=0.100000
     SteerBoneName="Master3z00"
     RevMeterScale=4000.000000
     ExhaustEffectClass=Class'ROEffects.ExhaustDieselEffect'
     ExhaustEffectLowClass=Class'ROEffects.ExhaustDieselEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-270.000000,Y=-30.000000,Z=23.000000),ExhaustRotation=(Pitch=31000))
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_HigginsBoatGunnerPawn',WeaponBone="mg_base")
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_HigginsPassengerOne',WeaponBone="passenger_L1")
     PassengerWeapons(2)=(WeaponPawnClass=Class'DH_Vehicles.DH_HigginsPassengerTwo',WeaponBone="passenger_L2")
     PassengerWeapons(3)=(WeaponPawnClass=Class'DH_Vehicles.DH_HigginsPassengerThree',WeaponBone="passenger_L3")
     PassengerWeapons(4)=(WeaponPawnClass=Class'DH_Vehicles.DH_HigginsPassengerFour',WeaponBone="passenger_R1")
     PassengerWeapons(5)=(WeaponPawnClass=Class'DH_Vehicles.DH_HigginsPassengerFive',WeaponBone="passenger_R2")
     PassengerWeapons(6)=(WeaponPawnClass=Class'DH_Vehicles.DH_HigginsPassengerSix',WeaponBone="passenger_R3")
     IdleSound=Sound'DH_AlliedVehicleSounds.HigginsIdle01'
     StartUpSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsStart01'
     ShutDownSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsStop01'
     DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.higgins.HigginsBoat_destroyed'
     DamagedEffectOffset=(X=-170.000000,Y=20.000000,Z=50.000000)
     VehicleTeam=1
     SteeringScaleFactor=2.000000
     BeginningIdleAnim="Higgins-Idle"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',TransitionUpAnim="Ramp_Drop",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true,ViewFOV=85.000000)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',TransitionDownAnim="Ramp_Raise",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,ViewFOV=85.000000)
     VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.higgins_body'
     VehicleHudOccupantsX(0)=0.430000
     VehicleHudOccupantsX(1)=0.570000
     VehicleHudOccupantsX(2)=0.430000
     VehicleHudOccupantsX(3)=0.430000
     VehicleHudOccupantsX(4)=0.430000
     VehicleHudOccupantsX(5)=0.570000
     VehicleHudOccupantsX(6)=0.570000
     VehicleHudOccupantsX(7)=0.570000
     VehicleHudOccupantsY(0)=0.670000
     VehicleHudOccupantsY(1)=0.670000
     VehicleHudOccupantsY(3)=0.400000
     VehicleHudOccupantsY(4)=0.500000
     VehicleHudOccupantsY(5)=0.300000
     VehicleHudOccupantsY(6)=0.400000
     VehicleHudOccupantsY(7)=0.500000
     VehicleHudEngineY=0.000000
     VehHitpoints(0)=(PointBone="driver_player",PointOffset=(Z=45.000000))
     VehHitpoints(1)=(PointRadius=50.000000,PointBone="Master1z00",PointOffset=(X=-160.000000,Z=60.000000))
     bIsApc=true
     DriverAttachmentBone="driver_player"
     Begin Object Class=SVehicleWheel Name=LFWheel
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Z=-6.000000)
         WheelRadius=30.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.LFWheel'

     Begin Object Class=SVehicleWheel Name=RFWheel
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Z=-6.000000)
         WheelRadius=30.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.RFWheel'

     Begin Object Class=SVehicleWheel Name=LRWheel
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Z=-6.000000)
         WheelRadius=30.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.LRWheel'

     Begin Object Class=SVehicleWheel Name=RRWheel
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Z=-6.000000)
         WheelRadius=30.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.RRWheel'

     VehicleMass=6.000000
     DrivePos=(Z=10.000000)
     DriveAnim="stand_idlehip_satchel"
     ExitPositions(0)=(X=-30.000000,Y=-38.000000,Z=150.000000)
     ExitPositions(1)=(X=-30.000000,Y=-38.000000,Z=150.000000)
     EntryRadius=350.000000
     FPCamPos=(Z=30.000000)
     TPCamDistance=375.000000
     TPCamLookat=(X=0.000000,Z=0.000000)
     TPCamWorldOffset=(Z=100.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a Higgins Boat"
     VehicleNameString="Higgins Boat"
     MaxDesireability=1.900000
     GroundSpeed=80.000000
     WaterSpeed=80.000000
     HealthMax=800.000000
     Health=800
     Mesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat'
     Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat'
     CollisionRadius=100.000000
     CollisionHeight=60.000000
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.300000
         KInertiaTensor(3)=4.000000
         KInertiaTensor(5)=4.500000
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KBuoyancy=1.200000
         KStartEnabled=true
         bKNonSphericalInertia=true
         bHighDetailOnly=false
         bClientOnly=false
         bKDoubleTickRate=true
         bKStayUpright=true
         bKAllowRotate=true
         bDestroyOnWorldPenetrate=true
         bDoSafetime=true
         KFriction=0.500000
         KImpactThreshold=850.000000
     End Object
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_HigginsBoat.KParams0'

     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=3
}
