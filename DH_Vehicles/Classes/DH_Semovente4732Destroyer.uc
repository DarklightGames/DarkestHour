//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// References:
// - https://comandosupremo.com/fiat-l6-40/
// - https://en.wikipedia.org/wiki/L6/40_tank
// - https://tanks-encyclopedia.com/ww2/italy/carro_armato_l6_40.php
// - https://tanks-encyclopedia.com/ww2/italy/semovente_da_47-32.php
//==============================================================================
// TODO:
// [ ] Interior mesh import
// [ ] Driver camera animations
// [ ] Fix camera clipping on driver's camera (move camera forward or down a few units)
// [ ] Make sure to copy the new handling code from the L6/40
// [ ] Projectile attachments
//==============================================================================

class DH_Semovente4732Destroyer extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Semovente L40 da 47/32"
    VehicleTeam=0
    VehicleMass=6.8
    ReinforcementCost=2

    // Periscope
    PeriscopePositionIndex=0
    PeriscopeCameraBone="SEMO_CAMERA_PERISCOPE"

    Skins(0)=Texture'DH_Semovente4732_tex.semo4732_body_ext'
    //Skins(1)=Texture'DH_Semovente4732_tex.semo4732_turret_ext'
    Skins(2)=Texture'DH_FiatL640_tex.fiatl640_treads'
    Skins(3)=Texture'DH_FiatL640_tex.fiatl640_treads'

    // Hull mesh
    Mesh=SkeletalMesh'DH_Semovente4732_anm.semovente4732_body_ext'

    // Vehicle weapons & passengers
    BeginningIdleAnim="closed"
    // TODO: probably need to slightly adjust the pose for the Semovente version
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Semovente4732CannonPawn',WeaponBone="TURRET_PLACEMENT")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=0,Y=0,Z=58),DriveRot=(Yaw=16384),DriveAnim="fiatl640_passenger_02",InitialViewRotationOffset=(Yaw=-16384))
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=0,Y=0,Z=58),DriveRot=(Yaw=16384),DriveAnim="fiatl640_passenger_01",InitialViewRotationOffset=(Yaw=-16384))

    // TODO: swap to INT
    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Semovente4732_anm.semovente4732_body_ext',TransitionUpAnim="overlay_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=-1,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Semovente4732_anm.semovente4732_body_ext',DriverTransitionAnim="fiatl640_driver_out",TransitionUpAnim="open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=57344,ViewPositiveYawLimit=24576,ViewNegativeYawLimit=-24576,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Semovente4732_anm.semovente4732_body_ext',DriverTransitionAnim="fiatl640_driver_in",TransitionDownAnim="close",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=true)
    DrivePos=(X=0,Y=0,Z=58)
    DriveRot=(Yaw=16384)
    DriveAnim="fiatl640_driver_closed"
    DriverAttachmentBone="driver_attachment"
    UnbuttonedPositionIndex=0
    bLockCameraDuringTransition=false

    // Hull armor
    // https://tanks-encyclopedia.com/ww2/italy/carro_armato_l6_40.php
    // "The front plates of the superstructure were 30 mm thick, while those of the gun shield and driver’s port were 40 mm thick.
    // The front plates of the transmission cover and the side plates were 15 mm thick, as was the rear. The engine deck was 6 mm
    // thick and the floor had 10 mm armor plates."
    FrontArmor(0)=(Thickness=3.0,Slope=-65.84,MaxRelativeHeight=32.3213,LocationName="lower slope")
    FrontArmor(1)=(Thickness=3.0,Slope=-15.27,MaxRelativeHeight=51.5188,LocationName="lower")
    FrontArmor(2)=(Thickness=1.5,Slope=75.82,MaxRelativeHeight=65.4981,LocationName="transmission cover")
    FrontArmor(3)=(Thickness=3.0,Slope=13.35,LocationName="upper")
    RightArmor(0)=(Thickness=1.5,Slope=0.0,MaxRelativeHeight=59.0221,LocationName="lower")
    RightArmor(1)=(Thickness=1.5,Slope=11.3,LocationName="upper")
    LeftArmor(0)=(Thickness=1.5,Slope=0.0,MaxRelativeHeight=59.0221,LocationName="lower")
    LeftArmor(1)=(Thickness=1.5,Slope=11.3,LocationName="upper")
    RearArmor(0)=(Thickness=1.5,Slope=0)

    FrontLeftAngle=330
    FrontRightAngle=30
    RearLeftAngle=208
    RearRightAngle=153

    // Movement
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.13

    // Damage
    Health=420
    HealthMax=420.0
    EngineHealth=300
    AmmoIgnitionProbability=0.5  // 0.75 default
    TurretDetonationThreshold=4000.0 // increased from 1750
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol

    // Hitpoints
    VehHitpoints(0)=(PointBone="BODY",PointRadius=27.1584,PointOffset=(X=-68.1716,Z=49.7671),HitPointType=HP_Engine)
    VehHitpoints(1)=(PointBone="BODY",PointRadius=16,PointOffset=(X=-19.1348,Y=38.7964,Z=68.5152),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointBone="BODY",PointRadius=16,PointOffset=(X=13.02052,Y=38.7964,Z=68.5152),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)

    TreadHitMaxHeight=55.0
    TreadDamageThreshold=0.5
    DamagedEffectOffset=(X=-70,Y=0,Z=80)
    DamagedEffectScale=1.0
    FireAttachBone="body"
    // TODO: add destroyed mesh
    DestroyedVehicleMesh=StaticMesh'DH_Semovente4732_stc.Destroyed.semovente4732_destroyed'
    ShadowZOffset=20.0

    DamagedTrackStaticMeshLeft=StaticMesh'DH_FiatL640_stc.fiatl640_tracks_dest_L'
    DamagedTrackStaticMeshRight=StaticMesh'DH_FiatL640_stc.fiatl640_tracks_dest_R'

    FireEffectOffset=(X=40,Y=15,Z=60)

    // Exit
    ExitPositions(0)=(X=-10.00,Y=96.00,Z=60.00)     // Driver
    ExitPositions(1)=(X=-10.00,Y=-96.00,Z=60.00)    // Gunner
    ExitPositions(2)=(X=-65.00,Y=-105.00,Z=55.00)   // Passenger Left
    ExitPositions(3)=(X=-65.00,Y=105.00,Z=55.00)    // Passenger Right
    ExitPositions(4)=(X=-85.00,Y=-25.00,Z=140.00)   // Engine Dock Left
    ExitPositions(5)=(X=-85.00,Y=25.00,Z=140.00)    // Engine Dock Right
    ExitPositions(6)=(X=-165.00,Y=-35.00,Z=55.00)   // Rear Left
    ExitPositions(7)=(X=-165.00,Y=35.00,Z=55.00)    // Rear Right

    // Sounds
    SoundPitch=48
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart.stuart_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.T60.t60_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.T60.t60_engine_stop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="body"
    RumbleSound=Sound'DH_AlliedVehicleSounds.stuart.stuart_inside_rumble'

    // Visual effects
    LeftTreadIndex=2
    RightTreadIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    TreadVelocityScale=100.0
    WheelRotationScale=45500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-115.924,Y=48.0646,Z=60.461),ExhaustRotation=(Pitch=32768))
    LeftLeverBoneName="LEVER_L"
    RightLeverBoneName="LEVER_R"

    // HUD
    VehicleHudImage=Texture'DH_Semovente4732_tex.interface.semovente4732_body'
    VehicleHudTurret=TexRotator'DH_Semovente4732_tex.interface.semovente4732_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Semovente4732_tex.interface.semovente4732_turret_look'

    VehicleHudEngineX=0.50

    VehicleHudTreadsPosX(0)=0.325
    VehicleHudTreadsPosX(1)=0.675
    VehicleHudTreadsPosY=0.50
    VehicleHudTreadsScale=0.8

    VehicleHudOccupantsX(0)=0.545
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsX(1)=0.425
    VehicleHudOccupantsY(1)=0.5
    VehicleHudOccupantsX(2)=0.35
    VehicleHudOccupantsY(2)=0.65
    VehicleHudOccupantsX(3)=0.65
    VehicleHudOccupantsY(3)=0.65

    SpawnOverlay(0)=Material'DH_Semovente4732_tex.interace.semovente4732_icon'

    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_FiatL640_stc.collision.fiatl640_driver_flap_collision',AttachBone="VISION_PORT")

    // VehicleAttachments(0)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Cannone4732_stc.deco.cannone4732_shell',Offset=(X=-116.391,Y=-31.8017,Z=46.0125))
    // VehicleAttachments(1)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Cannone4732_stc.deco.cannone4732_shell',Offset=(X=-116.391,Y=-21.5638,Z=46.0125))
    // VehicleAttachments(2)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Cannone4732_stc.deco.cannone4732_shell',Offset=(X=-116.391,Y=-26.7217,Z=37.901))
    // VehicleAttachments(3)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Cannone4732_stc.deco.cannone4732_shell',Offset=(X=-116.391,Y=-16.4839,Z=37.901))
    // VehicleAttachments(4)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Cannone4732_stc.deco.cannone4732_shell',Offset=(X=-116.391,Y=21.542,Z=46.0125))
    // VehicleAttachments(5)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Cannone4732_stc.deco.cannone4732_shell',Offset=(X=-116.391,Y=31.7799,Z=46.0125))
    // VehicleAttachments(6)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Cannone4732_stc.deco.cannone4732_shell',Offset=(X=-116.391,Y=16.4621,Z=37.901))
    // VehicleAttachments(7)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Cannone4732_stc.deco.cannone4732_shell',Offset=(X=-116.391,Y=26.7,Z=37.901))

    // Visible wheels
    LeftWheelBones(0)="WHEEL_01_L"
    LeftWheelBones(1)="WHEEL_02_L"
    LeftWheelBones(2)="WHEEL_03_L"
    LeftWheelBones(3)="WHEEL_04_L"
    LeftWheelBones(4)="WHEEL_05_L"
    LeftWheelBones(5)="WHEEL_06_L"
    LeftWheelBones(6)="WHEEL_07_L"
    LeftWheelBones(7)="WHEEL_08_L"
    LeftWheelBones(8)="WHEEL_09_L"

    RightWheelBones(0)="WHEEL_01_R"
    RightWheelBones(1)="WHEEL_02_R"
    RightWheelBones(2)="WHEEL_03_R"
    RightWheelBones(3)="WHEEL_04_R"
    RightWheelBones(4)="WHEEL_05_R"
    RightWheelBones(5)="WHEEL_06_R"
    RightWheelBones(6)="WHEEL_07_R"
    RightWheelBones(7)="WHEEL_08_R"
    RightWheelBones(8)="WHEEL_09_R"

    LeftTrackSoundBone="DRIVE_WHEEL_L"
    RightTrackSoundBone="DRIVE_WHEEL_R"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(0)=LF_Steering
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(1)=RF_Steering
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(2)=LR_Steering
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(3)=RR_Steering
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(4)=Left_Drive_Wheel
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(5)=Right_Drive_Wheel
}
