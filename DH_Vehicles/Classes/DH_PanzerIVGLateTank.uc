//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIVGLateTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\axis_panzer4F2_anm.ukx
#exec OBJ LOAD FILE=..\Animations\axis_panzer4H_anm.ukx
#exec OBJ LOAD FILE=..\Textures\axis_vehicles_tex.utx
#exec OBJ LOAD FILE=..\Textures\axis_vehicles_tex2.utx

defaultproperties
{
    MaxCriticalSpeed=729.0
    TreadDamageThreshold=0.75
    UFrontArmorFactor=8.2
    URightArmorFactor=3.0
    ULeftArmorFactor=3.0
    URearArmorFactor=2.1
    UFrontArmorSlope=12.0
    URearArmorSlope=9.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=103.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L05'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R05'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer4h_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer4h_turret_look'
    VehicleHudTreadsPosX(0)=0.36
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.71
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
    LeftWheelBones(11)="Wheel_L_12"
    LeftWheelBones(12)="Wheel_L_13"
    LeftWheelBones(13)="Wheel_L_14"
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
    RightWheelBones(11)="Wheel_R_12"
    RightWheelBones(12)="Wheel_R_13"
    RightWheelBones(13)="Wheel_R_14"
    WheelRotationScale=550
    TreadHitMinAngle=1.8
    FrontLeftAngle=332.0
    RearLeftAngle=208.0
    GearRatios(4)=0.65
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-170.0,Z=35.0),ExhaustRotation=(Pitch=22000,Yaw=9000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVGLateCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVMountedMGPawn',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-115.0,Y=-70.0,Z=55.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-150.0,Y=-35.0,Z=55.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-150.0,Y=35.0,Z=55.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-115.0,Y=70.0,Z=55.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")
    IdleSound=SoundGroup'Vehicle_Engines.PanzerIV.PanzerIV_engine_loop'
    StartUpSound=sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_start'
    ShutDownSound=sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_stop'
    DestroyedVehicleMesh=StaticMesh'axis_vehicles_stc.Panzer4G.Panzer4G_destroyed'
    DisintegrationHealth=-1000.0
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=2300,ViewPitchDownLimit=64000,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanzer4_driver_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=61000,ViewPositiveYawLimit=5000,ViewNegativeYawLimit=-10000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanzer4_driver_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=65536,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.panzer4g_body'
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(2)=0.57
    VehicleHudOccupantsX(3)=0.375
    VehicleHudOccupantsY(3)=0.7
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.75
    VehicleHudOccupantsX(6)=0.625
    VehicleHudOccupantsY(6)=0.7
    VehHitpoints(0)=(PointRadius=32.0,PointHeight=35.0,PointOffset=(X=-100.0,Z=6.0)) // engine
    VehHitpoints(1)=(PointRadius=10.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=-27.0,Z=-10.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=10.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=27.0,Z=-10.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-30.0,Y=25.0,Z=10.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=30.0,Y=-7.0,Z=10.0)
        WheelRadius=30.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_PanzerIVGLateTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=30.0,Y=7.0,Z=10.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_PanzerIVGLateTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-12.0,Y=-7.0,Z=10.0)
        WheelRadius=30.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_PanzerIVGLateTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-12.0,Y=7.0,Z=10.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_PanzerIVGLateTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=30.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_PanzerIVGLateTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_PanzerIVGLateTank.Right_Drive_Wheel'
    bFPNoZFromCameraPitch=true
    ExitPositions(0)=(X=104.0,Y=-37.0,Z=110.0)
    ExitPositions(1)=(X=-128.0,Y=0.0,Z=160.0)
    ExitPositions(2)=(X=105.0,Y=44.0,Z=115.0)
    ExitPositions(3)=(X=-121.0,Y=-163.0,Z=5.0)
    ExitPositions(4)=(X=-251.0,Y=-35.0,Z=5.0)
    ExitPositions(5)=(X=-251.0,Y=35.0,Z=5.0)
    ExitPositions(6)=(X=-121.0,Y=163.0,Z=5.0)
    EntryRadius=375.0
    DriverDamageMult=1.0
    VehicleNameString="Panzer IV Ausf.G"
    MaxDesireability=1.8
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=525.0
    Health=525
    Mesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_body_ext'
    Skins(0)=texture'axis_vehicles_tex.ext_vehicles.Panzer4F2_ext'
    Skins(1)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(2)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(3)=texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    CollisionRadius=175.0
    CollisionHeight=60.0
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.Panzer4f2_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.panzer4_g'
}
