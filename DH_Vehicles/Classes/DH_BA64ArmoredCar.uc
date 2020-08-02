//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BA64ArmoredCar extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="BA64 Armored Car"
    VehicleTeam=1
    bIsApc=true
    bHasTreads=false
    bSpecialTankTurning=false
    VehicleMass=3.0
    ReinforcementCost=2

    bMustBeTankCommander=false

    // Hull mesh
    Mesh=SkeletalMesh'DH_BA64_anm.BA64_body_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.BA64_ext'
    Skins(1)=Texture'allies_vehicles_tex.int_vehicles.BA64_int'
    HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.BA64_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_BA64MGPawn',WeaponBone=turret_placement) 

    // Driver
    DriverAttachmentBone=driver_attachment
    bMultiPosition=true
    DriverPositions(0)=(PositionMesh=Mesh'DH_BA64_anm.BA64_body_int',DriverTransitionAnim=none,TransitionUpAnim=Overlay_Out,ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bExposed=false,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=Mesh'DH_BA64_anm.BA64_body_int',DriverTransitionAnim=VBA64_driver_close,TransitionUpAnim=driver_hatch_open,TransitionDownAnim=Overlay_in,ViewPitchUpLimit=2730,ViewPitchDownLimit=60065,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=false)
    DriverPositions(2)=(PositionMesh=Mesh'DH_BA64_anm.BA64_body_int',DriverTransitionAnim=VBA64_driver_open,TransitionDownAnim=driver_hatch_close,ViewPitchUpLimit=9500,ViewPitchDownLimit=62835,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500,bExposed=true)
    DriveAnim=VBA64_driver_idle_close
    BeginningIdleAnim=driver_hatch_idle_close

    // Driver overlay
    HUDOverlayClass=class'ROVehicles.BA64DriverOverlay'
    HUDOverlayOffset=(X=2,Y=0,Z=0)
    HUDOverlayFOV=85

    // Hull armor
    FrontArmor(0)=(Thickness=0.6,Slope=-30.0,MaxRelativeHeight=-13.0,LocationName="lower nose") // all height values are wrong and need to be changed
    FrontArmor(1)=(Thickness=0.9,Slope=30.0,MaxRelativeHeight=-4.0,LocationName="mid nose")
    FrontArmor(2)=(Thickness=0.9,Slope=52.0,MaxRelativeHeight=8.25,LocationName="upper nose")
    FrontArmor(3)=(Thickness=0.6,Slope=84.0,MaxRelativeHeight=18.0,LocationName="engine plate")
    FrontArmor(4)=(Thickness=1.5,Slope=40.0,LocationName="driver plate")

    RightArmor(0)=(Thickness=0.9,Slope=-30.0,MaxRelativeHeight=3.0,LocationName="lower")
    RightArmor(1)=(Thickness=0.9,Slope=30.0,LocationName="upper")
    LeftArmor(0)=(Thickness=0.9,Slope=-30.0,MaxRelativeHeight=3.0,LocationName="lower")
    LeftArmor(1)=(Thickness=0.9,Slope=30.0,LocationName="upper")

    RearArmor(0)=(Thickness=0.6,Slope=-35.0,MaxRelativeHeight=-11.0,LocationName="lower")
    RearArmor(1)=(Thickness=0.9,Slope=30.0,LocationName="upper")

    FrontLeftAngle=338.0
    FrontRightAngle=22.0
    RearRightAngle=158.0
    RearLeftAngle=202.0

    // Movement
    MaxCriticalSpeed=1400.0 //~80 kph
    WheelSoftness=0.025000
    WheelPenScale=1.200000
    WheelPenOffset=0.010000
    WheelRestitution=0.100000
    WheelInertia=0.100000
    WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
    WheelLongSlip=0.001000
    WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
    WheelLongFrictionScale=1.100000
    WheelLatFrictionScale=1.55
    WheelHandbrakeSlip=0.010000
    WheelHandbrakeFriction=0.100000
    WheelSuspensionTravel=10.000000
    WheelSuspensionMaxRenderTravel=5.000000
    FTScale=0.030000
    ChassisTorqueScale=0.095
    MinBrakeFriction=4.000000
    MaxSteerAngleCurve=(Points=((OutVal=45.000000),(InVal=300.000000,OutVal=30.000000),(InVal=500.000000,OutVal=20.000000),(InVal=600.000000,OutVal=15.000000),(InVal=1000000000.000000,OutVal=10.000000)))
    SteerSpeed=160.000000
    TurnDamping=35.000000
    StopThreshold=100.000000
    HandbrakeThresh=200.000000
    LSDFactor=1.000000
    CenterSpringForce="SpringONSSRV"

    SteerBoneName="Steering"
    SteerBoneAxis=AXIS_X
    SteeringScaleFactor=4.0

    bHasHandbrake=True
    TorqueCurve=(Points=((InVal=0,OutVal=1.0),(InVal=200,OutVal=0.75),(InVal=1500,OutVal=2.0),(InVal=2200,OutVal=0.0)))
    GearRatios(0)=-0.20
    GearRatios(1)=0.20
    GearRatios(2)=0.42
    GearRatios(3)=0.80
    GearRatios(4)=1.05
    TransRatio=0.16
    ChangeUpPoint=1990.000000
    ChangeDownPoint=1000.000000
    EngineBrakeFactor=0.000100
    EngineBrakeRPMScale=0.100000
    MaxBrakeTorque=20.000000
    EngineInertia=0.100000
    IdleRPM=500.000000
    EngineRPMSoundRange=5000.000000
    RevMeterScale=4000.000000
    //GroundSpeed=325.000000
	//^ for some reason this line makes it slow as hell, and it doesnt exist on gaz67 so i removed it

    // Damage
    Health=500.0
    HealthMax=500.0
    DirectHEImpactDamageMult=8.0
    EngineHealth=50
    VehHitpoints(0)=(PointRadius=22.0,PointHeight=0.0,PointScale=1.0,PointBone=engine,PointOffset=(X=60.0,Y=0.0,Z=-10.0),bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine)

    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=-20.0,Y=0.0,Z=30.0)
    DriverKillChance=900.0
    CommanderKillChance=600.0
    TraverseDamageChance=1250.0
    DestroyedVehicleMesh=StaticMesh'DH_BA64_stc.Ba64_destoyed'

    // Exit
    ExitPositions(0)=(X=-92.0,Y=4.0,Z=150.0)
    ExitPositions(1)=(X=-92.0,Y=4.0,Z=150.0)

    // Sounds
    IdleSound=sound'Vehicle_Engines.BA64.ba64_engine_loop'
    StartUpSound=sound'Vehicle_Engines.BA64.ba64_engine_start'
    ShutDownSound=sound'Vehicle_Engines.BA64.ba64_engine_stop'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-20,Y=30,Z=-35),ExhaustRotation=(pitch=34000,yaw=-5000,roll=0))
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'

    // HUD
    VehicleHudImage=Texture'InterfaceArt_tex.Tank_Hud.BA64_body'
    VehicleHudEngineX=0.5
    VehicleHudEngineY=0.3
    VehicleHudOccupantsX(0)=0.5
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsX(2)=none
    VehicleHudOccupantsY(0)=0.5
    VehicleHudOccupantsY(1)=0.665
    VehicleHudOccupantsY(2)=none
    //SpawnOverlay(0)=Material'  <to do

    // Physics wheels
     Begin Object Class=SVehicleWheel Name=LFWheel
         bPoweredWheel=False
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
          BoneOffset=(Y=-9.000000,Z=2.0)
         WheelRadius=26.000000
         SupportBoneName="Axle_RF"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_BA64ArmoredCar.LFWheel'

     Begin Object Class=SVehicleWheel Name=RFWheel
         bPoweredWheel=False
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=9.000000,Z=2.0)
         WheelRadius=26.000000
         SupportBoneName="Axle_LF"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_BA64ArmoredCar.RFWheel'

     Begin Object Class=SVehicleWheel Name=LRWheel
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=0.0,Y=-9.000000,Z=2.0)
         WheelRadius=26.000000
         SupportBoneName="Axle_LR"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_BA64ArmoredCar.LRWheel'

     Begin Object Class=SVehicleWheel Name=RRWheel
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=0.0,Y=9.000000,Z=2.0)
         WheelRadius=26.000000
         SupportBoneName="Axle_RR"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_BA64ArmoredCar.RRWheel'

    // Karma
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.300000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(X=0.30000,Z=-0.5250)
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=True
         bKNonSphericalInertia=True
         bHighDetailOnly=False
         bClientOnly=False
         bKDoubleTickRate=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=0.500000
         KImpactThreshold=700.000000
     End Object
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_BA64ArmoredCar.KParams0'
}
