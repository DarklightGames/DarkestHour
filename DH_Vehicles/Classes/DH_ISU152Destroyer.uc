//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

//=====================================================================
// Original ISU-152 for Red Orchestra:
// Skins, models & animation by Paul Pepera, with sounds by Eric Parris
//=====================================================================

class DH_ISU152Destroyer extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="ISU-152"
    VehicleTeam=1
    VehicleMass=13.5
    ReinforcementCost=7

    // Hull mesh
    Mesh=SkeletalMesh'DH_ISU152_anm.ISU152-body_ext'
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.isu152_body_ext'
    Skins(1)=Texture'DH_VehiclesSOV_tex.Treads.isu152_treads'
    Skins(2)=Texture'DH_VehiclesSOV_tex.Treads.isu152_treads'
    Skins(3)=Texture'DH_VehiclesSOV_tex.int_vehicles.isu152_body_int'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ISU152CannonPawn',WeaponBone="Turret_Placement")
    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-120.0,Y=-50.0,Z=82.0),DriveRot=(Yaw=-4096),DriveAnim="crouch_idle_binoc")
    PassengerPawns(1)=(AttachBone="Body",DrivePos=(X=-140.0,Y=0.0,Z=82.0),DriveAnim="crouch_idle_binoc")
    PassengerPawns(2)=(AttachBone="Body",DrivePos=(X=-120.0,Y=50.0,Z=82.0),DriveRot=(Yaw=4096),DriveAnim="crouch_idle_binoc")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-body_int',TransitionUpAnim="Overlay_Out",ViewPitchDownLimit=65535,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VSU76_driver_close",ViewPitchUpLimit=1000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VSU76_driver_open",ViewPitchUpLimit=14500,ViewPitchDownLimit=57000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-12000,bExposed=true)
    UnbuttonedPositionIndex=3 // can't unbutton, no proper exit hatch for driver (small opening hatch is just for vision)
    DrivePos=(X=10.0,Y=0.0,Z=-41.0) // adjusted from original
    DriveAnim="VIS2_driver_idle_close"
    HUDOverlayClass=class'ROVehicles.KV1DriverOverlay'
    HUDOverlayFOV=85.0

    // Hull armor
    FrontArmor(0)=(Thickness=9.0,Slope=-30.0,MaxRelativeHeight=-15.0,LocationName="lower") // note: sources agree IS2 (our base hull) had 100mm, but show ISU-152 having 90mm
    FrontArmor(1)=(Thickness=6.0,Slope=78.0,MaxRelativeHeight=1.0,LocationName="upper")
    FrontArmor(2)=(Thickness=9.0,Slope=30.0,LocationName="superstructure")
    RightArmor(0)=(Thickness=9.0,MaxRelativeHeight=0.8,LocationName="lower")
    RightArmor(1)=(Thickness=7.5,Slope=15.0,LocationName="superstructure")
    LeftArmor(0)=(Thickness=9.0,MaxRelativeHeight=0.8,LocationName="lower")
    LeftArmor(1)=(Thickness=7.5,Slope=15.0,LocationName="superstructure")
    RearArmor(0)=(Thickness=6.0,Slope=-41.0,MaxRelativeHeight=-12.8,LocationName="lower")
    RearArmor(1)=(Thickness=6.0,Slope=49.0,MaxRelativeHeight=24.2,LocationName="upper")
    RearArmor(2)=(Thickness=6.0,LocationName="superstructure")

    FrontLeftAngle=322.0 // angles adjusted from original
    FrontRightAngle=38.0
    RearRightAngle=163.0
    RearLeftAngle=197.0

    // Movement
    GearRatios(4)=0.72
    TransRatio=0.09
    GearRatios(0)=-0.35

    // Damage
	// pros: Diesel fuel, 5 men crew
	// cons: high caliber ammorack is more likely to detonate; fuel tanks in the crew compartment
    Health=525
    HealthMax=525.0
	EngineHealth=300
	AmmoIgnitionProbability=0.9  // 0.75 default
    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel
    TurretDetonationThreshold=1300.0 // reduced from 1750 (this vehicle is turretless though? i am not sure how this works so put it here just in case)
    VehHitpoints(0)=(PointRadius=35.0,PointBone="Engine",PointOffset=(X=-25.0,Y=0.0,Z=-5.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-70.0,Y=50.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=50.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=10.0,Z=-20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=-5.0
    DamagedEffectOffset=(X=-210.0,Y=0.0,Z=40.0) // adjusted from original
    FireAttachBone="Body"
    FireEffectOffset=(X=90.0,Y=-28.0,Z=15.0)
    DestroyedVehicleMesh=StaticMesh'DH_Soviet_vehicles_stc.ISU152.ISU152_dest'

    // Exit positions
    ExitPositions(0)=(X=165.0,Y=-25.0,Z=50.0)  // driver
    ExitPositions(1)=(X=10.0,Y=50.0,Z=200.0)   // commander
    ExitPositions(2)=(X=-140.00,Y=-160.00,Z=50.00) // riders
    ExitPositions(3)=(X=-360.00,Y=0.00,Z=-50.00)
    ExitPositions(4)=(X=-140.00,Y=160.00,Z=50.00)

    // Sounds
    MaxPitchSpeed=100.0
    IdleSound=Sound'Vehicle_Engines.IS2.IS2_engine_loop' // was SU76 engine sound but vehicle is built off IS2 chassis & engine
    StartUpSound=Sound'Vehicle_Engines.IS2.IS2_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.IS2.IS2_engine_stop'
    LeftTrackSoundBone="Tread_L"
    RightTrackSoundBone="Tread_R"
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02' // was custom 'ISU152_engine_loop', but using same as IS2 as same chassis & engine

    // Visual effects
    TreadVelocityScale=125.0
    WheelRotationScale=65000.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-220.0,Y=60.0,Z=30.0),ExhaustRotation=(Pitch=34000,Roll=-10000)) // positions adjusted from original
    ExhaustPipes(1)=(ExhaustPosition=(X=-220.0,Y=-60.0,Z=30.0),ExhaustRotation=(Pitch=34000,Roll=10000))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.isu152_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.isu152_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.isu152_turret_look'
    VehicleHudTreadsPosX(0)=0.38 // some positions adjusted from original
    VehicleHudTreadsPosX(1)=0.64
    VehicleHudTreadsScale=0.7
    VehicleHudOccupantsX(0)=0.46
    VehicleHudOccupantsY(0)=0.26
    VehicleHudOccupantsX(1)=0.592
    VehicleHudOccupantsY(1)=0.36
    VehicleHudOccupantsX(2)=0.4
    VehicleHudOccupantsY(2)=0.6
    VehicleHudOccupantsX(3)=0.5
    VehicleHudOccupantsY(3)=0.625
    VehicleHudOccupantsX(4)=0.6
    VehicleHudOccupantsY(4)=0.6
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.ISU152'

    // Visible wheels
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    LeftWheelBones(7)="Wheel_L_8"
    LeftWheelBones(8)="Wheel_L_9"
    LeftWheelBones(9)="Wheel_L_10"
    LeftWheelBones(10)="Wheel_L_11"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"
    RightWheelBones(7)="Wheel_R_8"
    RightWheelBones(8)="Wheel_R_9"
    RightWheelBones(9)="Wheel_R_10"
    RightWheelBones(10)="Wheel_R_11"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=30.0,Y=-10.0)
        WheelRadius=27.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.LF_Steering'

    Begin Object Class=SVehicleWheel Name=RF_Steering
    bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=30.0,Y=10.0)
        WheelRadius=27.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.RF_Steering'

    Begin Object Class=SVehicleWheel Name=LR_Steering
    bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-18.0,Y=-10.0)
        WheelRadius=26.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.LR_Steering'

    Begin Object Class=SVehicleWheel Name=RR_Steering
    bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-18.0,Y=10.0)
        WheelRadius=26.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.RR_Steering'

    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0)
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.Left_Drive_Wheel'

    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=10.0)
        WheelRadius=28.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.55) // default is -0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.75 // default is 1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_ISU152Destroyer.KParams0'
}
