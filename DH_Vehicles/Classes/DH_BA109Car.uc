//-----------------------------------------------------------
// Props to Moz
//-----------------------------------------------------------
class DH_BA109Car extends ROChopperCraft;

#exec OBJ LOAD FILE=..\Animations\allies_ba64_anm.ukx
#exec OBJ LOAD FILE=..\Textures\Vehicle_Optic.utx
#exec OBJ LOAD FILE=..\textures\DH_BA64Custom.utx

// wheel params
var()	float			WheelSoftness;
var()	float			WheelPenScale;
var()	float			WheelPenOffset;
var()	float			WheelRestitution;
var()	float			WheelAdhesion;
var()	float			WheelInertia;
var()	InterpCurve		WheelLongFrictionFunc;
var()	float			WheelLongSlip;
var()	InterpCurve		WheelLatSlipFunc;
var()	float			WheelLongFrictionScale;
var()	float			WheelLatFrictionScale;
var()	float			WheelHandbrakeSlip;
var()	float			WheelHandbrakeFriction;
var()	float			WheelSuspensionTravel;
var()	float			WheelSuspensionOffset;
var()	float			WheelSuspensionMaxRenderTravel;

var()	float			MinBrakeFriction;

var()   float   MaxPitchSpeed;

var		int					PendingPositionIndex;	// Position index the client is trying to switch to

/* =================================================================================== *
* NextViewPoint()
* Handles switching to the next view point in the list of available viewpoints
* for the driver.
*
* created by: Ramm 10/08/04
* =================================================================================== */
simulated function NextViewPoint()
{
	 GotoState('ViewTransition');
}

function ServerChangeViewPoint(bool bForward)
{
	if (bForward)
	{
		if ( DriverPositionIndex < (DriverPositions.Length - 1) )
		{
			PreviousPositionIndex = DriverPositionIndex;
			DriverPositionIndex++;

			if(  Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer )
			{
				NextViewPoint();
			}
		}
	}
	else
	{
		if ( DriverPositionIndex > 0 )
		{
			PreviousPositionIndex = DriverPositionIndex;
			DriverPositionIndex--;

			if(  Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer )
			{
				NextViewPoint();
			}
		}
	}
}

simulated function PostNetReceive()
{
	super.PostNetReceive();

	if ( DriverPositionIndex != SavedPositionIndex )
	{
		PreviousPositionIndex = SavedPositionIndex;
		SavedPositionIndex = DriverPositionIndex;
		NextViewPoint();
	}

	// Kill the engine sounds if the engine is dead
	if( EngineHealth <= 0 )
	{
		if( IdleSound != none )
			IdleSound=none;

		if( StartUpSound != none )
			StartUpSound=none;

		if( ShutDownSound != none )
			ShutDownSound=none;

		if( AmbientSound != none )
			AmbientSound=none;
	}
}

simulated function NextWeapon()
{
	if( !bMultiPosition || IsInState('ViewTransition') || DriverPositionIndex != PendingPositionIndex)
		return;

	// Make sure the client doesn't switch positions while the server is changing position indexes
	if ( DriverPositionIndex < (DriverPositions.Length - 1) )
	{
		PendingPositionIndex = DriverPositionIndex + 1;
	}

	ServerChangeViewPoint(true);
}

// Overriden to switch viewpoints while driving
simulated function PrevWeapon()
{
	if( !bMultiPosition || IsInState('ViewTransition') || DriverPositionIndex != PendingPositionIndex)
		return;

    // Make sure the client doesn't switch positions while the server is changing position indexes
	if ( DriverPositionIndex > 0 )
	{
		PendingPositionIndex = DriverPositionIndex - 1;
	}

	ServerChangeViewPoint(false);
}

// Subclassed to remove onslaught functionality we don't need. This actually never happens in our game yet.
simulated event TeamChanged()
{
/*    local int i;

	// MergeTODO: Don't think we need any of this
	for (i = 0; i < Weapons.Length; i++)
		Weapons[i].SetTeam(Team); */
}

// Allow behindview for debugging
exec function ToggleViewLimit()
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() || Level.NetMode != NM_Standalone  )
		return;

	if( bAllowViewChange )
	{
		bAllowViewChange=false;
		bDontUsePositionMesh = false;
		bLimitYaw = true;
		bLimitPitch = true;
	}
	else
	{
		bAllowViewChange=true;
		bDontUsePositionMesh = true;
		bLimitYaw = false;
		bLimitPitch = false;
	}
}


simulated event DrivingStatusChanged()
{
    if (bDriving)
        Enable('Tick');
    else
        Disable('Tick');
}

simulated function Tick(float DeltaTime)
{
    local float EnginePitch;

    if(Level.NetMode != NM_DedicatedServer)
	{
        EnginePitch = 96.0 + VSize(Velocity)/MaxPitchSpeed * 32.0;
        SoundPitch = FClamp(EnginePitch, 96, 128);
    }


    Super.Tick(DeltaTime);
}

simulated event SVehicleUpdateParams()
{
	local int i;

	Super.SVehicleUpdateParams();

	for(i=0; i<Wheels.Length; i++)
	{
		Wheels[i].Softness = WheelSoftness;
		Wheels[i].PenScale = WheelPenScale;
		Wheels[i].PenOffset = WheelPenOffset;
		Wheels[i].LongSlip = WheelLongSlip;
		Wheels[i].LatSlipFunc = WheelLatSlipFunc;
		Wheels[i].Restitution = WheelRestitution;
		Wheels[i].Adhesion = WheelAdhesion;
		Wheels[i].WheelInertia = WheelInertia;
		Wheels[i].LongFrictionFunc = WheelLongFrictionFunc;
		Wheels[i].HandbrakeFrictionFactor = WheelHandbrakeFriction;
		Wheels[i].HandbrakeSlipFactor = WheelHandbrakeSlip;
		Wheels[i].SuspensionTravel = WheelSuspensionTravel;
		Wheels[i].SuspensionOffset = WheelSuspensionOffset;
		Wheels[i].SuspensionMaxRenderTravel = WheelSuspensionMaxRenderTravel;
	}

}

defaultproperties
{
     WheelPenScale=1.200000
     WheelPenOffset=0.010000
     WheelRestitution=0.100000
     WheelInertia=1000.099976
     WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
     WheelLongSlip=0.001000
     WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
     WheelLongFrictionScale=1.100000
     WheelLatFrictionScale=1.550000
     WheelHandbrakeSlip=0.010000
     WheelHandbrakeFriction=0.100000
     WheelSuspensionTravel=10.000000
     WheelSuspensionMaxRenderTravel=5.000000
     MinBrakeFriction=40.000000
     MaxPitchSpeed=4500.000000
     UprightStiffness=500.000000
     UprightDamping=300.000000
     MaxThrustForce=200.000000
     LongDamping=0.100000
     MaxStrafeForce=50.000000
     LatDamping=0.100000
     MaxRiseForce=100.000000
     UpDamping=0.100000
     TurnTorqueFactor=1000.000000
     TurnTorqueMax=200.000000
     TurnDamping=50.000000
     MaxYawRate=1.500000
     PitchTorqueFactor=200.000000
     PitchTorqueMax=35.000000
     PitchDamping=30.000000
     RollTorqueTurnFactor=450.000000
     RollTorqueStrafeFactor=50.000000
     RollTorqueMax=70.000000
     RollDamping=40.000000
     StopThreshold=100.000000
     MaxRandForce=0.100000
     RandForceInterval=0.750000
     DriverWeapons(0)=(WeaponClass=Class'ROStuffDeeival.BA109Gun',WeaponBone="Turret_placement")
     IdleSound=SoundGroup'Vehicle_Engines.BA64.ba64_engine_loop'
     StartUpSound=Sound'Vehicle_Engines.BA64.BA64_engine_start'
     ShutDownSound=Sound'Vehicle_Engines.BA64.BA64_engine_stop'
     DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.BA64.BA64_Destoyed'
     DestructionEffectClass=Class'ROEffects.ROVehicleDestroyedEmitter'
     DisintegrationEffectClass=Class'ROEffects.ROVehicleDestroyedEmitter'
     DisintegrationHealth=-10000.000000
     DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
     DestructionAngularMomentum=(Max=150.000000)
     DamagedEffectScale=0.750000
     DamagedEffectOffset=(X=60.000000,Y=10.000000,Z=10.000000)
     TimeTilDissapear=30.000000
     BeginningIdleAnim="driver_hatch_idle_close"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'allies_ba64_anm.BA64_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=65535,ViewPitchDownLimit=65535,bDrawOverlays=True)
     VehicleHudImage=Texture'InterfaceArt_tex.Tank_Hud.BA64_body'
     VehicleHudOccupantsX(0)=0.500000
     VehicleHudOccupantsX(2)=0.000000
     VehicleHudOccupantsY(0)=0.500000
     VehicleHudOccupantsY(1)=0.665000
     VehicleHudOccupantsY(2)=0.000000
     VehicleHudEngineY=0.300000
     VehHitpoints(0)=(PointRadius=7.000000,PointScale=1.000000,PointBone="driver_player",PointOffset=(X=-10.000000,Z=-7.000000),HitPointType=HP_Driver)
     VehHitpoints(1)=(PointRadius=22.000000,PointScale=1.000000,PointBone="Engine",PointOffset=(X=60.000000,Z=-10.000000),DamageMultiplier=5.000000,HitPointType=HP_Engine)
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=LFWheel1
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-9.000000,Z=2.000000)
         WheelRadius=26.000000
         SupportBoneName="Axle_RF"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(0)=SVehicleWheel'ROStuffDeeival.BA109Car.LFWheel1'

     Begin Object Class=SVehicleWheel Name=RFWheel1
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=9.000000,Z=2.000000)
         WheelRadius=26.000000
         SupportBoneName="Axle_LF"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(1)=SVehicleWheel'ROStuffDeeival.BA109Car.RFWheel1'

     Begin Object Class=SVehicleWheel Name=LRWheel1
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-9.000000,Z=2.000000)
         WheelRadius=26.000000
         SupportBoneName="Axle_LR"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(2)=SVehicleWheel'ROStuffDeeival.BA109Car.LRWheel1'

     Begin Object Class=SVehicleWheel Name=RRWheel1
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=9.000000,Z=2.000000)
         WheelRadius=26.000000
         SupportBoneName="Axle_RR"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(3)=SVehicleWheel'ROStuffDeeival.BA109Car.RRWheel1'

     VehicleMass=4.000000
     bTeamLocked=False
     bHasHandbrake=True
     DriveAnim="VBA64_driver_idle_close"
     ExitPositions(0)=(Y=-200.000000,Z=100.000000)
     ExitPositions(1)=(Y=200.000000,Z=100.000000)
     ExitPositions(2)=(Y=-200.000000,Z=100.000000)
     ExitPositions(3)=(Y=200.000000,Z=100.000000)
     EntryRadius=160.000000
     FPCamPos=(X=42.000000,Y=-18.000000,Z=33.000000)
     TPCamDistance=350.000000
     TPCamLookat=(X=0.000000,Z=0.000000)
     TPCamWorldOffset=(Z=100.000000)
     VehiclePositionString="in the BA-109"
     VehicleNameString="BA-109"
     MaxDesireability=0.600000
     ObjectiveGetOutDist=1500.000000
     HUDOverlayClass=Class'ROVehicles.BA64DriverOverlay'
     HUDOverlayOffset=(X=2.000000)
     HUDOverlayFOV=85.000000
     bCanBeBaseForPawns=True
     GroundSpeed=100000.000000
     HealthMax=500.000000
     Health=500
     Mesh=SkeletalMesh'allies_ba64_anm.BA64_body_ext'
     Skins(0)=Texture'BA64Custom.ext_vehicles.BA109'
     Skins(1)=Texture'allies_vehicles_tex.int_vehicles.BA64_int'
     SoundRadius=600.000000
     CollisionRadius=175.000000
     CollisionHeight=40.000000
     Begin Object Class=KarmaParamsRBFull Name=KParams1100
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.500000
         KCOMOffset=(X=-0.250000)
         KLinearDamping=0.500000
         KAngularDamping=0.500000
         KStartEnabled=True
         bKNonSphericalInertia=True
         KActorGravScale=0.000000
         bHighDetailOnly=False
         bClientOnly=False
         bKDoubleTickRate=True
         bKStayUpright=True
         bKAllowRotate=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=1.500000
         KImpactThreshold=300.000000
     End Object
     KParams=KarmaParamsRBFull'ROStuffDeeival.BA109Car.KParams1100'

     HighDetailOverlay=Shader'allies_vehicles_tex.int_vehicles.BA64_int_s'
     bUseHighDetailOverlayIndex=True
     HighDetailOverlayIndex=1
}
