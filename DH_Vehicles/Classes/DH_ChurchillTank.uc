//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ChurchillTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Churchill_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Churchill_tex.utx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Churchill Mk.VII"
    VehicleTeam=1
    VehicleMass=13.0
    ReinforcementCost=10

    // Hull mesh
    Mesh=SkeletalMesh'DH_Churchill_anm.ext_body'
    Skins(0)=texture'DH_Churchill_tex.churchill.churchill_body'
    Skins(1)=texture'DH_Churchill_tex.churchill.churchill_turret'
    Skins(2)=texture'DH_Churchill_tex.churchill.churchill_track'
    Skins(3)=texture'DH_Churchill_tex.churchill.churchill_track'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ChurchillCannonPawn',WeaponBone="turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_ChurchillMountedMGPawn',WeaponBone="mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-80.0,Y=-100.0,Z=100.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-190.0,Y=-75.0,Z=105.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-190.0,Y=75.0,Z=105.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-80.0,Y=100.0,Z=100.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    InitialPositionIndex=2
    UnbuttonedPositionIndex=3
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Churchill_anm.int_body',TransitionUpAnim="Vision_hatch_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=59000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Churchill_anm.int_body',TransitionUpAnim="overlay_Out",TransitionDownAnim="Vision_hatch_open",ViewPitchUpLimit=0,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Churchill_anm.int_body',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="overlay_in",DriverTransitionAnim="VUC_driver_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=59000,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Churchill_anm.int_body',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=59000,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,bExposed=true)
    DriveAnim="VUC_driver_idle_close"
    OverlayFPCamPos=(X=9.0,Y=0.0,Z=0.0)

    // Hull armor
    FrontArmor(0)=(Thickness=2.54,Slope=-62.0,MaxRelativeHeight=36.0,LocationName="lower nose")
    FrontArmor(1)=(Thickness=5.72,Slope=-20.0,MaxRelativeHeight=50.5,LocationName="nose")
    FrontArmor(2)=(Thickness=2.96,Slope=70.0,MaxRelativeHeight=67.5,LocationName="glacis")
    FrontArmor(3)=(Thickness=6.35,LocationName="upper")
    RightArmor(0)=(Thickness=2.86,MaxRelativeHeight=79.0,LocationName="lower") // lower side armour was 1.5 inch front half & 1" back half, so split the difference
    RightArmor(1)=(Thickness=4.13,LocationName="upper")                        // upper side armour was 1.75" front half & 1.5" back half, so split the difference
    LeftArmor(0)=(Thickness=2.85,MaxRelativeHeight=79.0,LocationName="lower")
    LeftArmor(1)=(Thickness=4.13,LocationName="upper")
    RearArmor(0)=(Thickness=3.18)

    FrontLeftAngle=338.0
    FrontRightAngle=22.0
    RearRightAngle=157.0
    RearLeftAngle=203.0

    // Movement
    MaxCriticalSpeed=948.0 // 57 kph
    GearRatios(3)=0.6
    GearRatios(4)=0.8
    TransRatio=0.14a

    // Damage
    VehHitpoints(0)=(PointRadius=35.0,PointBone="engine")
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=-20.0,Y=40.0,Z=3.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=-20.0,Y=-40.0,Z=3.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=40.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=58.0
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-130.0,Y=0.0,Z=85.0)
    FireAttachBone="body"
    FireEffectOffset=(X=110.0,Y=35.0,Z=25.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Crommy_wrecked'

    // Exit
    ExitPositions(0)=(X=95.0,Y=30.0,Z=175.0)     // driver
    ExitPositions(1)=(X=0.0,Y=0.0,Z=210.0)       // commander
    ExitPositions(2)=(X=95.0,Y=-30.0,Z=175.0)    // hull MG
    ExitPositions(3)=(X=-85.0,Y=-160.0,Z=75.0)   // riders
    ExitPositions(4)=(X=-300.0,Y=-70.0,Z=75.0)
    ExitPositions(5)=(X=-300.0,Y=70.0,Z=75.0)
    ExitPositions(6)=(X=-85.0,Y=160.0,Z=75.0)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.T34.t34_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T34.t34_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T34.t34_engine_stop'
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L07'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L07'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'

    // Visual effects
    LeftTreadIndex=2
    RightTreadIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=-16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=-16384,Roll=0)
    LeftTrackSoundBone="drive_wheel_L"
    RightTrackSoundBone="drive_wheel_R"
    TreadVelocityScale=130.0
    WheelRotationScale=50000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-160.0,Y=0.0,Z=105.0),ExhaustRotation=(Pitch=30000))
    LeftLeverBoneName="Lever_L" // TODO: not sure if we want to even bother ehre
    RightLeverBoneName="Lever_R"
    SteeringScaleFactor=1.0

    // HUD
    VehicleHudImage=texture'DH_Churchill_tex.hud.churchill_body'
    VehicleHudTurret=TexRotator'DH_Churchill_tex.hud.churchill_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Churchill_tex.hud.churchill_turret_look'
    VehicleHudEngineX=0.505
    VehicleHudEngineY=0.76
    VehicleHudTreadsPosX(0)=0.36
    VehicleHudTreadsPosY=0.57
    VehicleHudTreadsScale=0.72
    VehicleHudOccupantsX(0)=0.56
    VehicleHudOccupantsY(0)=0.38
    VehicleHudOccupantsX(1)=0.50
    VehicleHudOccupantsY(1)=0.52
    VehicleHudOccupantsX(2)=0.46
    VehicleHudOccupantsY(2)=0.38
    VehicleHudOccupantsX(3)=0.41
    VehicleHudOccupantsY(3)=0.73
    VehicleHudOccupantsX(4)=0.41
    VehicleHudOccupantsY(4)=0.83
    VehicleHudOccupantsX(5)=0.60
    VehicleHudOccupantsY(5)=0.83
    VehicleHudOccupantsX(6)=0.60
    VehicleHudOccupantsY(6)=0.73
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.cromwell'

    // Visible wheels
    LeftWheelBones(0)="wheel_L_1"
    LeftWheelBones(1)="wheel_L_2"
    LeftWheelBones(2)="wheel_L_3"
    LeftWheelBones(3)="wheel_L_4"
    LeftWheelBones(4)="wheel_L_5"
    LeftWheelBones(5)="wheel_L_6"
    LeftWheelBones(6)="wheel_L_7"
    LeftWheelBones(7)="wheel_L_8"
    LeftWheelBones(8)="wheel_L_9"
    LeftWheelBones(9)="wheel_L_10"
    LeftWheelBones(10)="wheel_L_11"
    LeftWheelBones(11)="wheel_L_12"
    RightWheelBones(0)="wheel_R_1"
    RightWheelBones(1)="wheel_R_2"
    RightWheelBones(2)="wheel_R_3"
    RightWheelBones(3)="wheel_R_4"
    RightWheelBones(4)="wheel_R_5"
    RightWheelBones(5)="wheel_R_6"
    RightWheelBones(6)="wheel_R_7"
    RightWheelBones(7)="wheel_R_8"
    RightWheelBones(8)="wheel_R_9"
    RightWheelBones(9)="wheel_R_10"
    RightWheelBones(10)="wheel_R_11"
    RightWheelBones(11)="wheel_R_12"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(0)=LF_Steering
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(1)=RF_Steering
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(2)=LR_Steering
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"i t
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(3)=RR_Steering
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(4)=Left_Drive_Wheel
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(5)=Right_Drive_Wheel

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=0.0) // default is -0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.9 // default is 1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KParams0
}
