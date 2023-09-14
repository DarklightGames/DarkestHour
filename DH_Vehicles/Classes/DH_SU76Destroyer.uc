//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SU76Destroyer extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="SU-76M"
    VehicleTeam=1
    VehicleMass=8.0
    ReinforcementCost=4

    // Hull mesh
    Mesh=Mesh'DH_SU76_anm.SU76_body_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.SU76_ext'
    Skins(1)=Texture'allies_vehicles_tex.Treads.SU76_treads'
    Skins(2)=Texture'allies_vehicles_tex.Treads.SU76_treads'
    Skins(3)=Texture'allies_vehicles_tex.int_vehicles.SU76_int'

    HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.SU76_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

    // Collision
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc3.SU76.SU76_visor_Coll',AttachBone="hatch_driver") // collision attachment for driver's armoured visor

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_SU76CannonPawn',WeaponBone="Turret_Placement")
    //PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-120.0,Y=-50.0,Z=82.0),DriveRot=(Yaw=-4096),DriveAnim="crouch_idle_binoc")
    //PassengerPawns(1)=(AttachBone="Body",DrivePos=(X=-140.0,Y=0.0,Z=82.0),DriveAnim="crouch_idle_binoc")
    //to do: may be place 2 passengers on the frontal armor, left and right of the gun barrel

    // Driver
    DriverAttachmentBone=driver_attachment
    DriverPositions(0)=(PositionMesh=Mesh'DH_SU76_anm.SU76_body_int',DriverTransitionAnim=VSU76_driver_close,TransitionUpAnim=driver_hatch_open,ViewPitchUpLimit=0,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bExposed=true,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=Mesh'DH_SU76_anm.SU76_body_int',DriverTransitionAnim=VSU76_driver_open,TransitionDownAnim=driver_hatch_close,ViewPitchUpLimit=5000,ViewPitchDownLimit=65536,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-12000,bExposed=true)
    InitialPositionIndex=0
    UnbuttonedPositionIndex=1 // position in array where driver can exit
    FPCamPos=(X=0,Y=0,Z=0)
    FPCamViewOffset=(X=0,Y=0,Z=0)
    bFPNoZFromCameraPitch=True
    TPCamLookat=(X=-50,Y=0,Z=0)
    TPCamWorldOffset=(X=0,Y=0,Z=250)
    TPCamDistance=600
    DrivePos=(X=0.0,Y=0.0,Z=0.0)

    DriveAnim=VSU76_driver_idle_close
    BeginningIdleAnim=driver_hatch_idle_close
    HUDOverlayClass=class'ROVehicles.SU76DriverOverlay'
    HUDOverlayOffset=(X=0,Y=0,Z=0)
    HUDOverlayFOV=85

    // Hull armor
    FrontArmor(0)=(Thickness=3.0,Slope=-30.0,MaxRelativeHeight=-10.5,LocationName="lower nose")
    FrontArmor(1)=(Thickness=2.5,Slope=60.0,MaxRelativeHeight=23.5,LocationName="upper")
    FrontArmor(2)=(Thickness=2.5,Slope=20.0,LocationName="superstructure")
    RightArmor(0)=(Thickness=1.5,MaxRelativeHeight=23.5,LocationName="lower")
    RightArmor(1)=(Thickness=1.0,Slope=25.0,LocationName="superstructure")
    LeftArmor(0)=(Thickness=1.5,MaxRelativeHeight=23.5,LocationName="lower")
    LeftArmor(1)=(Thickness=1.0,Slope=25.0,LocationName="superstructure")
    RearArmor(0)=(Thickness=1.5,Slope=-30,MaxRelativeHeight=-15.0,LocationName="lower")
    RearArmor(1)=(Thickness=1.5,MaxRelativeHeight=42.0,LocationName="lower superstructure")
    RearArmor(2)=(Thickness=0.0,LocationName="upper superstructure") // literally no armor - open in the back

    FrontLeftAngle=322.0
    FrontRightAngle=38.0
    RearRightAngle=163.0
    RearLeftAngle=197.0

    // Movement
    MaxCriticalSpeed=870.0 // approximate; also something in between 140 and 170 horse power variants
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.12

    // Damage
    // pros:
    // cons: petrol fuel;
    Health=525
    HealthMax=525.0
    EngineHealth=300
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=9.0,PointHeight=0.0,PointScale=1.0,PointBone=driver_player,PointOffset=(X=-13.0,Y=-3.0,Z=-8.0),bPenetrationPoint=true,HitPointType=HP_Driver)
    VehHitpoints(1)=(PointRadius=35.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=25.0,Y=45.0,Z=-10.0),bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(2)=(PointRadius=25.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=-80.0,Y=-40.0,Z=5.0),bPenetrationPoint=false,DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    //below is from isu152
    //TreadHitMaxHeight=-5.0
    //DamagedEffectOffset=(X=-210.0,Y=0.0,Z=40.0)
    //FireEffectOffset=(X=90.0,Y=-28.0,Z=15.0)

    FireAttachBone="Body"
    DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.SU76_Destroyed'

    // Exit positions
    ExitPositions(0)=(X=250,Y=000,Z=50)
    ExitPositions(1)=(X=-50,Y=000,Z=250)

    // Sounds
    // replaced sounds from ro1's SU-76 to T-60, because ro1 sound for SU76 doesnt really sound authentic for it, SU-76 used the same engine as on T-60 but doubled
    SoundPitch=32 // half normal pitch = 1 octave lower
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart.stuart_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.T60.t60_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.T60.t60_engine_stop'
    RumbleSoundBone="body"
    RumbleSound=Sound'Vehicle_Engines.tank_inside_rumble01'

    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'

    // Visual effects
    TreadVelocityScale=85.0
    WheelRotationScale=29250.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-130,Y=75,Z=25),ExhaustRotation=(pitch=34000,yaw=-3000,roll=0))
    ExhaustPipes(1)=(ExhaustPosition=(X=-130,Y=85,Z=25),ExhaustRotation=(pitch=34000,yaw=-3000,roll=0))
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.SU76_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.SU76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.SU76_turret_look'

    VehicleHudEngineX=0.45
    VehicleHudEngineY=0.67
    VehicleHudOccupantsX(0)=0.5
    VehicleHudOccupantsX(1)=0.57
    VehicleHudOccupantsX(2)=none
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(1)=0.5
    VehicleHudOccupantsY(2)=none
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.su76m'

    // Visible wheels
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    LeftWheelBones(7)="Wheel_L_8"
    // Track Return wheels
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
    // Track Return wheels
    RightWheelBones(8)="Wheel_R_9"
    RightWheelBones(9)="Wheel_R_10"
    RightWheelBones(10)="Wheel_R_11"


    // Wheels
    // Steering Wheels
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=True
         BoneOffset=(X=35.0,Y=-5.0,Z=10.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_LF"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_SU76Destroyer.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=True
        BoneOffset=(X=35.0,Y=5.0,Z=10.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_RF"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_SU76Destroyer.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-7.0,Y=-5.0,Z=10.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_LR"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_SU76Destroyer.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-7.0,Y=5.0,Z=10.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RR"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_SU76Destroyer.RR_Steering'
     // End Steering Wheels

     // Center Drive Wheels
     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=0.0,Z=10.0)
         BoneName="Drive_Wheel_L"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_SU76Destroyer.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=0.0,Z=10.0)
         BoneName="Drive_Wheel_R"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_SU76Destroyer.Right_Drive_Wheel'

    // Karma
    // not sure if this is set up correctly? ro1 su76 class doesnt seem to have that
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.5)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_SU76Destroyer.KParams0'
}
