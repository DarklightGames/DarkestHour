//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_KV1sTank extends DHArmoredVehicle;  //to do: is the standart texture really accurate? It's a light blue/grey color, i never found any images of such KV-1S

defaultproperties
{
    // Vehicle properties
    VehicleNameString="KV-1S"
    VehicleTeam=1
    VehicleMass=15.2  //should be above 15.1 (or whatever is set in gebalte ladung) so its resistant to gebalte ladung, due to relatively thick top armor (30-40mm)
    ReinforcementCost=5

    // Hull mesh
    Mesh=SkeletalMesh'DH_KV_anm.KV1S_body_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.KV1_ext'
    Skins(1)=Texture'allies_vehicles_tex.Treads.kv1_treads'
    Skins(2)=Texture'allies_vehicles_tex.Treads.kv1_treads'
    Skins(3)=Texture'allies_vehicles_tex.int_vehicles.kv1_int'
    HighDetailOverlay=Shader'allies_vehicles_tex.int_vehicles.kv1_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_KV1sCannonPawn',WeaponBone="Turret_Placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_KV1sMGPawn',WeaponBone="MG_Placement")
    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-133.0,Y=-42.0,Z=104.5),DriveRot=(Pitch=200),DriveAnim="crouch_idle_binoc") // kneeling, as can't sit in usual position due to fuel drums
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-195.0,Y=-35.0,Z=46.0),DriveRot=(Yaw=-32768),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="Body",DrivePos=(X=-195.0,Y=35.0,Z=46.0),DriveRot=(Yaw=-32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="Body",DrivePos=(X=-133.0,Y=31.0,Z=104.5),DriveRot=(Pitch=200),DriveAnim="crouch_idle_binoc")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_KV_anm.KV1S_body_int',DriverTransitionAnim="VKV1_driver_close",TransitionUpAnim="driver_hatch_open",ViewPitchDownLimit=65535,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_KV_anm.KV1S_body_int',DriverTransitionAnim="VKV1_driver_open",TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=11000,ViewNegativeYawLimit=-11000,bExposed=true)
    InitialPositionIndex=0
    DrivePos=(X=10.0,Y=0.0,Z=1.0) // moved forward so driver isn't enveloped in hull collision mesh & can be shot // TODO: either make a hole in collision mesh or change anims to improve result
    UnbuttonedPositionIndex=1 // TODO: animated hatch is vision only & driver couldn't exit - either prevent driver exit or re-work models to include exit hatch that is overhead & to left
    DriveAnim="VKV1_driver_idle_close"

    // Driver overlay
    HUDOverlayClass=class'ROVehicles.KV1DriverOverlay'
    HUDOverlayOffset=(X=0,Y=0,Z=0)
    HUDOverlayFOV=85

    // Hull armor
    FrontArmor(0)=(Thickness=6.0,Slope=-25.0,MaxRelativeHeight=6.5,LocationName="lower")
    FrontArmor(1)=(Thickness=5.0,Slope=70.0,MaxRelativeHeight=26.0,LocationName="upper")
    FrontArmor(2)=(Thickness=7.5,Slope=30.0,LocationName="driver plate")
    RightArmor(0)=(Thickness=6.0)
    LeftArmor(0)=(Thickness=6.0)
    RearArmor(0)=(Thickness=6.0,Slope=-45.0,MaxRelativeHeight=-15.0,LocationName="lower (bottom of curved)")
    RearArmor(1)=(Thickness=6.0,MaxRelativeHeight=8.0,LocationName="lower (flattest curved)") // represents flattest, rear facing part of rounded lower hull
    RearArmor(2)=(Thickness=6.0,Slope=45.0,MaxRelativeHeight=23.5,LocationName="lower (top of curved)")
    RearArmor(3)=(Thickness=6.0,Slope=50.0,MaxRelativeHeight=38.0,LocationName="upper")
    RearArmor(4)=(Thickness=3.0,Slope=82.0,LocationName="upper slope")

    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    MaxCriticalSpeed=674.0 // 40 kph
    GearRatios(4)=0.7
    TransRatio=0.08

    EngineRestartFailChance=0.1  //later improved and lightened design

    // Damage
    // Compared to KV-1:
    // pros: later, more polished design from 1942 that eliminated some of the early reliability problems.
    Health=565
    HealthMax=565.0
    EngineHealth=300 // better than on KV-1/KV-1E because its a "lightweight" modification with less stress on engine and transmission

    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel
      // more reliable engine and transmission due to lower weight and later, more polished design
    VehHitpoints(0)=(PointRadius=40.0,PointOffset=(X=-100.0,Y=0.0,Z=0.0)) // engine // TODO: check position of all hit points
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=13.0,Y=-25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=13.0,Y=25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=26.0
    DamagedEffectOffset=(X=-90.0,Y=0.0,Z=40.0)
    DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.Kv1_Destroyed'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.Destroyed.KV1S_ext_dest'
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesSOV_tex.Destroyed.KV1S_treads_dest'

    // Exit
    ExitPositions(0)=(X=235.0,Y=0.0,Z=50.0)     // driver
    ExitPositions(1)=(X=13.0,Y=26.0,Z=200.0)    // commander
    ExitPositions(2)=(X=125.0,Y=-130.0,Z=50.0)  // hull MG
    ExitPositions(3)=(X=-133.0,Y=-135.0,Z=75.0) // riders
    ExitPositions(4)=(X=-240.0,Y=-35.0,Z=75.0)
    ExitPositions(5)=(X=-240.0,Y=35.0,Z=75.0)
    ExitPositions(6)=(X=-133.0,Y=135.0,Z=75.0)

    // Sounds
    MaxPitchSpeed=450.0
    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.track_squeak_L04'
    RightTreadSound=Sound'Vehicle_Engines.track_squeak_R04'
    RumbleSound=Sound'Vehicle_Engines.tank_inside_rumble02'

    // Visual effects
    TreadVelocityScale=115.0
    WheelRotationScale=50000.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-100.0,Y=47.0,Z=50.0),ExhaustRotation=(Yaw=12000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-100.0,Y=-47.0,Z=50.0),ExhaustRotation=(Yaw=-12000))

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.KV-1S_body'
    VehicleHudTurret=TexRotator'InterfaceArt_tex.Tank_Hud.kv1s_turret_rot'
    VehicleHudTurretLook=TexRotator'InterfaceArt_tex.Tank_Hud.kv1s_turret_look'
    VehicleHudTreadsPosX(0)=0.37
    VehicleHudTreadsPosX(1)=0.64
    VehicleHudTreadsScale=0.73
    VehicleHudOccupantsX(0)=0.5
    VehicleHudOccupantsY(0)=0.25
    VehicleHudOccupantsY(1)=0.41
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.3
    VehicleHudOccupantsX(3)=0.44
    VehicleHudOccupantsY(3)=0.72
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.84
    VehicleHudOccupantsX(5)=0.56
    VehicleHudOccupantsY(5)=0.84
    VehicleHudOccupantsX(6)=0.57
    VehicleHudOccupantsY(6)=0.72
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.KV1s'

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
         BoneName="Steer_Wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=10.0,Y=-10.0,Z=13.0)
         WheelRadius=41.0
         bLeftTrack=true
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_KV1sTank.LF_Steering'
     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="Steer_Wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=10.0,Y=10.0,Z=13.0)
         WheelRadius=41.0
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_KV1sTank.RF_Steering'
     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-12.0,Y=-10.0,Z=13.0)
         WheelRadius=41.0
         bLeftTrack=true
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_KV1sTank.LR_Steering'
     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-12.0,Y=10.0,Z=13.0)
         WheelRadius=41.0
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_KV1sTank.RR_Steering'
     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=true
         BoneName="Drive_Wheel_L"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=0.0,Y=-10.0,Z=13.0)
         WheelRadius=41.0
         bLeftTrack=true
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_KV1sTank.Left_Drive_Wheel'
     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=true
         BoneName="Drive_Wheel_R"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=0.0,Y=10.0,Z=13.0)
         WheelRadius=41.0
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_KV1sTank.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.1)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.4 // default is 1.0 (lower value for slower, 'heavier' turns)
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_KV1sTank.KParams0'
}
