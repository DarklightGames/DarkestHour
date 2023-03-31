//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CromwellTank extends DHArmoredVehicle;

// Modified to adjust size/proportions of texture overlay to match driver's glass vision block
simulated function DrawPeriscopeOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = float(C.SizeY) / float(C.SizeX);
    C.SetPos(0.0, 0.0);
    C.DrawTile(PeriscopeOverlay, C.SizeX, C.SizeY, 0.0, (1.0 - ScreenRatio) * float(PeriscopeOverlay.VSize) * 0.6, PeriscopeOverlay.USize, float(PeriscopeOverlay.VSize) * ScreenRatio * 0.85);
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Cromwell Mk.IV"
    VehicleTeam=1
    VehicleMass=13.0
    ReinforcementCost=4

    // Hull mesh
    Mesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_ext'
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_armor_ext'
    Skins(2)=Texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int'
    Skins(3)=Texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int2'
    Skins(4)=Texture'DH_VehiclesUK_tex.Treads.Cromwell_treads'
    Skins(5)=Texture'DH_VehiclesUK_tex.Treads.Cromwell_treads'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_CromwellCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_CromwellMountedMGPawn',WeaponBone="MG_attachment")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-82.0,Y=-65.0,Z=45.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-151.0,Y=-65.0,Z=45.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-151.0,Y=66.0,Z=45.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-82.0,Y=66.0,Z=45.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    InitialPositionIndex=2
    UnbuttonedPositionIndex=3
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_int',TransitionUpAnim="Vision_hatch_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=59000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_int',TransitionUpAnim="Overlay_Out",TransitionDownAnim="Vision_hatch_open",ViewPitchUpLimit=0,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VUC_driver_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=59000,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=59000,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,bExposed=true)
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

    FrontRightAngle=27.0
    RearRightAngle=153.0

    // Movement
    MaxCriticalSpeed=948.0 // 57 kph
    GearRatios(3)=0.6
    GearRatios(4)=0.8
    TransRatio=0.14

    // Damage
	// pros: 5 men crew
	// cons: petrol fuel
    Health=565
    HealthMax=565.0
	EngineHealth=300

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=35.0,PointOffset=(X=-95.0,Z=2.0)) // engine
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=-20.0,Y=40.0,Z=3.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=-20.0,Y=-40.0,Z=3.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=40.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=58.0
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-130.0,Y=0.0,Z=85.0)
    FireAttachBone="Body"
    FireEffectOffset=(X=110.0,Y=35.0,Z=25.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Crommy_wrecked'

    // Exit
    ExitPositions(0)=(X=125.0,Y=35.0,Z=175.0)   // driver
    ExitPositions(1)=(X=25.0,Y=-35.0,Z=250.0)   // commander
    ExitPositions(2)=(X=125.0,Y=35.0,Z=175.0)   // hull MG
    ExitPositions(3)=(X=-77.0,Y=-160.0,Z=75.0)  // riders
    ExitPositions(4)=(X=-142.0,Y=-160.0,Z=75.0)
    ExitPositions(6)=(X=-142.0,Y=160.0,Z=75.0)
    ExitPositions(5)=(X=-77.0,Y=160.0,Z=75.0)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.T34.t34_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.T34.t34_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.T34.t34_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'

    // Visual effects
    LeftTreadIndex=4
    RightTreadIndex=5
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    TreadVelocityScale=78.0
    WheelRotationScale=24375.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-195.0,Y=30.0,Z=95.0),ExhaustRotation=(Pitch=36000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-195.0,Y=-30.0,Z=95.0),ExhaustRotation=(Pitch=36000))
    LeftLeverBoneName="Lever_L"
    RightLeverBoneName="Lever_R"
    SteeringScaleFactor=1.0

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.cromwell_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_Rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_Look'
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
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.cromwell'

    // Visible wheels
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="Steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=-10.0,Z=2.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_CromwellTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="Steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_CromwellTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="Steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-12.0,Y=-10.0,Z=2.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_CromwellTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="Steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-12.0,Y=10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_CromwellTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="Drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=10.0,Z=2.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_CromwellTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="Drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_CromwellTank.Right_Drive_Wheel'

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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_CromwellTank.KParams0'
}
