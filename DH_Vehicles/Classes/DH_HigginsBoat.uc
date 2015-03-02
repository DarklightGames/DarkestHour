//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HigginsBoat extends DH_BoatVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_HigginsBoat_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx

var     sound       RampDownSound;
var     sound       RampUpSound;
var     float       RampSoundVolume;
var     name        RampDownIdleAnim;


static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat');

    super.UpdatePrecacheMaterials();
}

// Overridden because the animation needs to play on the server for this vehicle for the driver's hit detection
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (Level.NetMode == NM_DedicatedServer)
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

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (Level.NetMode == NM_DedicatedServer)
            {
                GoToState('ViewTransition');
            }
        }
    }
}

// Overwritten to add Higgins Boat ramp sounds
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositions[DriverPositionIndex].PositionMesh != none && !bDontUsePositionMesh)
            {
                LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }
        }

        if (PreviousPositionIndex < DriverPositionIndex && HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
        {
            PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
            PlayOwnedSound(RampUpSound, SLOT_Misc, RampSoundVolume / 255.0,, 150.0,, false);
        }
        else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
        {
            PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
            PlayOwnedSound(RampDownSound, SLOT_Misc, RampSoundVolume / 255.0,, 150.0,, false);
        }

        if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim))
        {
            Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
        }
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

    InitialPositionIndex = DriverPositionIndex;
    PreviousPositionIndex = InitialPositionIndex;

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
    InitialPositionIndex = DriverPositionIndex;
    super.DriverDied();
    DriverLeft();
    MaybeDestroyVehicle();
}

// Called by notifies
function RampUpIdle()
{
    LoopAnim(BeginningIdleAnim);
    DestAnimName = BeginningIdleAnim;
}

function RampDownIdle()
{
    LoopAnim(RampDownIdleAnim);
    DestAnimName = RampDownIdleAnim;
}

event RanInto(Actor Other)
{
}

function bool EncroachingOn(Actor Other)
{
    return false;
}

defaultproperties
{
    RampDownSound=sound'DH_AlliedVehicleSounds.higgins.HigginsRampClose01'
    RampUpSound=sound'DH_AlliedVehicleSounds.higgins.HigginsRampOpen01'
    RampSoundVolume=180.0
    RampDownIdleAnim="Ramp_Idle"
    DriverCameraBoneName="Camera_driver"
    WashSound=sound'DH_AlliedVehicleSounds.higgins.wash01'
    WashSoundBoneL="Wash_L"
    WashSoundBoneR="Wash_R"
    EngineSound=SoundGroup'DH_AlliedVehicleSounds.higgins.HigginsEngine_loop'
    EngineSoundBone="Engine"
    DestAnimName="Higgins-Idle"
    DestAnimRate=1.0
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongSlip=0.001
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=1.55
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0
    FTScale=0.03
    ChassisTorqueScale=0.095
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((OutVal=45.0),(InVal=300.0,OutVal=30.0),(InVal=500.0,OutVal=20.0),(InVal=600.0,OutVal=15.0),(InVal=1000000000.0,OutVal=10.0)))
    TorqueCurve=(Points=((OutVal=1.0),(InVal=200.0,OutVal=0.75),(InVal=1500.0,OutVal=2.0),(InVal=2200.0)))
    GearRatios(0)=-0.2
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.5
    GearRatios(4)=0.63
    TransRatio=0.09
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=20.0
    TurnDamping=50.0
    StopThreshold=100.0
    HandbrakeThresh=200.0
    EngineInertia=0.1
    SteerBoneName="Master3z00"
    RevMeterScale=4000.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-270.0,Y=-30.0,Z=23.0),ExhaustRotation=(Pitch=31000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsBoatGunnerPawn',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerOne',WeaponBone="Master1z00")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerTwo',WeaponBone="Master1z00")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerThree',WeaponBone="Master1z00")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerFour',WeaponBone="Master1z00")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerFive',WeaponBone="Master1z00")
    PassengerWeapons(6)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerSix',WeaponBone="Master1z00")
    IdleSound=sound'DH_AlliedVehicleSounds.HigginsIdle01'
    StartUpSound=sound'DH_AlliedVehicleSounds.higgins.HigginsStart01'
    ShutDownSound=sound'DH_AlliedVehicleSounds.higgins.HigginsStop01'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.higgins.HigginsBoat_destroyed'
    DamagedEffectOffset=(X=-170.0,Y=20.0,Z=50.0)
    VehicleTeam=1
    SteeringScaleFactor=2.0
    BeginningIdleAnim="Higgins-Idle"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',TransitionUpAnim="Ramp_Drop",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',TransitionDownAnim="Ramp_Raise",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.higgins_body'
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(1)=0.57
    VehicleHudOccupantsX(2)=0.43
    VehicleHudOccupantsX(3)=0.43
    VehicleHudOccupantsX(4)=0.43
    VehicleHudOccupantsX(5)=0.57
    VehicleHudOccupantsX(6)=0.57
    VehicleHudOccupantsX(7)=0.57
    VehicleHudOccupantsY(0)=0.67
    VehicleHudOccupantsY(1)=0.67
    VehicleHudOccupantsY(3)=0.4
    VehicleHudOccupantsY(4)=0.5
    VehicleHudOccupantsY(5)=0.3
    VehicleHudOccupantsY(6)=0.4
    VehicleHudOccupantsY(7)=0.5
    VehicleHudEngineY=0.0
    VehHitpoints(0)=(PointBone="driver_player",PointOffset=(Z=45.0))
    VehHitpoints(1)=(PointRadius=50.0,PointBone="Master1z00",PointOffset=(X=-160.0,Z=60.0))
    bIsApc=true
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=LFWheel
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.LFWheel'
    Begin Object Class=SVehicleWheel Name=RFWheel
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.RFWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.LRWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.RRWheel'
    VehicleMass=6.0
    DrivePos=(Z=10.0)
    DriveAnim="stand_idlehip_satchel"
    ExitPositions(0)=(X=-30.0,Y=-38.0,Z=150.0)
    ExitPositions(1)=(X=-30.0,Y=-38.0,Z=150.0)
    EntryRadius=350.0
    FPCamPos=(Z=30.0)
    TPCamDistance=375.0
    TPCamLookat=(X=0.0,Z=0.0)
    TPCamWorldOffset=(Z=100.0)
    DriverDamageMult=1.0
    VehicleNameString="Higgins Boat"
    MaxDesireability=1.9
    GroundSpeed=80.0
    WaterSpeed=80.0
    HealthMax=800.0
    Health=800
    Mesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat'
    DestroyedVehicleTexture=texture'DH_VehiclesUS_tex.Destroyed.HigginsBoat_dest'
    CollisionRadius=100.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=4.0
        KInertiaTensor(5)=4.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KBuoyancy=1.2
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bKStayUpright=true
        bKAllowRotate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=850.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_HigginsBoat.KParams0'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
}
