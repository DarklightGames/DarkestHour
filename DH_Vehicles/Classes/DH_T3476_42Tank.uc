//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3476_42Tank extends DHArmoredVehicle;

simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    DestroyedSkin.Material1 = Skins[0];
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[0];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[0] = DestroyedSkin;

    super.DestroyAppearance();
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="T34/76 m42"
    VehicleTeam=1
    ReinforcementCost=4

    // Hull mesh
    Mesh=SkeletalMesh'DH_T34_2_anm.T34m42_body_ext'
    Skins(0)=Texture'DH_T34_3_tex.Vehicles.T3476_M42_green'
    Skins(1)=Texture'allies_vehicles_tex.Treads.T3476_treads'
    Skins(2)=Texture'allies_vehicles_tex.Treads.T3476_treads'

    bUseHighDetailOverlayIndex=false
    //HighDetailOverlayIndex=3
    //HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.t3476_int_s'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_T3476_42CannonPawn',WeaponBone="Turret_Placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_T3476MountedMGPawn',WeaponBone="MG_Placement")
    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-59.0,Y=-50.0,Z=53.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-100.0,Y=-25.0,Z=105.5),DriveAnim="crouch_idle_binoc") // kneeling, as can't sit in usual position due to fuel drum
    PassengerPawns(2)=(AttachBone="Body",DrivePos=(X=-135.0,Y=35.0,Z=51.0),DriveRot=(Yaw=-32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="Body",DrivePos=(X=-59.0,Y=50.0,Z=54.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    InitialPositionIndex=0
    UnbuttonedPositionIndex=1
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_T34_2_anm.T34m42_hull_int',TransitionUpAnim="driver_hatch_open",DriverTransitionAnim="Vt3485_driver_close",ViewPitchUpLimit=0,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_T34_2_anm.T34m42_hull_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="Vt3485_driver_open",ViewPitchUpLimit=5500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=11000,ViewNegativeYawLimit=-12500,bExposed=true)
    DriveAnim="VT3476_driver_idle_close"
    HUDOverlayClass=class'ROVehicles.T3476DriverOverlay'
    HUDOverlayFOV=85.0

    // Hull armor
    FrontArmor(0)=(Thickness=4.5,Slope=-60.0,MaxRelativeHeight=-7.0,LocationName="lower")
    FrontArmor(1)=(Thickness=4.5,Slope=60.0,LocationName="upper")
    RightArmor(0)=(Thickness=4.5,MaxRelativeHeight=13.2,LocationName="lower")
    RightArmor(1)=(Thickness=4.5,Slope=40.0,LocationName="upper")
    LeftArmor(0)=(Thickness=4.5,MaxRelativeHeight=13.2,LocationName="lower")
    LeftArmor(1)=(Thickness=4.5,Slope=40.0,LocationName="upper")
    RearArmor(0)=(Thickness=4.5,Slope=-45.0,MaxRelativeHeight=-0.4,LocationName="lower")
    RearArmor(1)=(Thickness=4.5,Slope=48.0,LocationName="upper")

    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    MaxCriticalSpeed=948.0 // 57 kph
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.13

    // Damage
	// pros: diesel fuel
	// cons: cramped turret; fuel tanks in crew compartment
	// 4 men crew
    Health=470
    HealthMax=470
    EngineHealth=300

    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel
    VehHitpoints(0)=(PointRadius=40.0,PointOffset=(X=-90.0,Y=0.0,Z=0.0)) // engine
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=13.0,Y=-25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=13.0,Y=25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=5.0
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-105.0,Y=0.0,Z=40.0) // adjusted from original
    FireAttachBone="Body"
    FireEffectOffset=(X=127.0,Y=-18.0,Z=25.0)
    DestroyedVehicleMesh=StaticMesh'DH_soviet_vehicles_stc.T34.T34m42Des'
    //DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.Destroyed.T3476_ext_dest'
    //DestroyedMeshSkins(1)=Combiner'DH_VehiclesSOV_tex.Destroyed.T3476_treads_dest'

    // Exit positions
    ExitPositions(0)=(X=215.0,Y=-14.0,Z=50.0)  // driver
    ExitPositions(1)=(X=25.0,Y=-5.0,Z=200.0)   // commander
    ExitPositions(2)=(X=215.0,Y=41.0,Z=50.0)   // hull MG
    ExitPositions(3)=(X=-43.0,Y=-125.0,Z=75.0) // riders
    ExitPositions(4)=(X=-220.0,Y=-35.0,Z=75.0)
    ExitPositions(5)=(X=-220.0,Y=37.0,Z=75.0)
    ExitPositions(6)=(X=-43.0,Y=125.0,Z=75.0)

    // Sounds
    SoundPitch=32 // half normal pitch = 1 octave lower
    MaxPitchSpeed=50.0
    IdleSound=SoundGroup'Vehicle_Engines.T34.t34_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.T34.t34_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.T34.t34_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'

    // Visual effects
    TreadVelocityScale=110.0
    WheelRotationScale=29250.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-175,Y=30,Z=10),ExhaustRotation=(Pitch=36000,Yaw=0,Roll=0))
    ExhaustPipes(1)=(ExhaustPosition=(X=-175,Y=-30,Z=10),ExhaustRotation=(Pitch=36000,Yaw=0,Roll=0))

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.t34_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.t34_76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.t34_76_turret_look'
    VehicleHudTreadsPosX(0)=0.36 // some positions adjusted from original
    VehicleHudTreadsScale=0.73
    VehicleHudOccupantsX(0)=0.465
    VehicleHudOccupantsY(0)=0.27
    VehicleHudOccupantsX(2)=0.565
    VehicleHudOccupantsY(1)=0.47
    VehicleHudOccupantsX(3)=0.42
    VehicleHudOccupantsY(3)=0.62
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.72
    VehicleHudOccupantsX(5)=0.57
    VehicleHudOccupantsY(5)=0.73
    VehicleHudOccupantsX(6)=0.58
    VehicleHudOccupantsY(6)=0.62
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.T34m42'

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
         BoneOffset=(X=35.0,Y=-10.0,Z=2.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_LF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
         bLeftTrack=true
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_T3476_42Tank.LF_Steering'
     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=true
        BoneOffset=(X=35.0,Y=10.0,Z=2.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_RF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_T3476_42Tank.RF_Steering'
     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=true
         BoneOffset=(X=-12.0,Y=-10.0,Z=2.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_LR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
         bLeftTrack=true
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_T3476_42Tank.LR_Steering'
     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=true
         BoneOffset=(X=-12.0,Y=10.0,Z=2.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_T3476_42Tank.RR_Steering'
     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=true
         BoneOffset=(X=0.0,Y=10.0,Z=2.0)
         BoneName="Drive_Wheel_L"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
         bLeftTrack=true
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_T3476_42Tank.Left_Drive_Wheel'
     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=true
         BoneOffset=(X=0.0,Y=-10.0,Z=2.0)
         BoneName="Drive_Wheel_R"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_T3476_42Tank.Right_Drive_Wheel'
}
