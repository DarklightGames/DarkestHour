//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIIILTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Panzer3_anm.ukx
#exec OBJ LOAD FILE=..\Textures\axis_vehicles_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2

defaultproperties
{
    UnbuttonedPositionIndex=3
    LeftTreadIndex=2
    RightTreadIndex=3
    MaxCriticalSpeed=729.0
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    UFrontArmorFactor=7.2
    URightArmorFactor=3.0
    ULeftArmorFactor=3.0
    URearArmorFactor=5.0
    UFrontArmorSlope=9.0
    URearArmorSlope=9.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=98.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3l_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3l_turret_look'
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
    WheelRotationScale=750
    TreadHitMinAngle=1.8
    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=150.0
    RearLeftAngle=210.0
    GearRatios(4)=0.65
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-175.0,Y=-52.0,Z=55.0),ExhaustRotation=(Pitch=22000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIILCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIIMountedMGPawn',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-90.0,Y=-55.0,Z=50.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-120.0,Y=-30.0,Z=50.0),DriveRot=(Pitch=3500,Yaw=32768),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-125.0,Y=30.0,Z=50.0),DriveRot=(Pitch=3900,Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-90.0,Y=60.0,Z=50.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")
    IdleSound=SoundGroup'Vehicle_Engines.Panzeriii.PanzerIII_engine_loop'
    StartUpSound=sound'Vehicle_Engines.Panzeriii.PanzerIII_engine_start'
    ShutDownSound=sound'Vehicle_Engines.Panzeriii.PanzerIII_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3L_dest2'
    DamagedEffectScale=0.85
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    SteeringScaleFactor=0.75
    BeginningIdleAnim="periscope_idle_out"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_body_int',TransitionUpAnim="periscope_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65536,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,ViewFOV=70.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_body_int',TransitionUpAnim="Overlay_In",TransitionDownAnim="Periscope_in",ViewPitchUpLimit=4000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_body_int',TransitionDownAnim="Overlay_Out",ViewPitchUpLimit=6000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.panzer3n_body'
    VehHitpoints(0)=(PointRadius=30.0,PointHeight=32.0,PointOffset=(X=-70.0,Z=6.0)) // engine
    VehHitpoints(1)=(PointRadius=10.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=-25.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=10.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=25.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-30.0,Y=25.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=40.0,Y=-5.0,Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_PanzerIIILTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=40.0,Y=5.0,Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_PanzerIIILTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-5.0,Y=-5.0,Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_PanzerIIILTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-5.0,Y=5.0,Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_PanzerIIILTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_PanzerIIILTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_PanzerIIILTank.Right_Drive_Wheel'
    VehicleMass=11.5
    bDrawDriverInTP=false
    bFPNoZFromCameraPitch=true
    ExitPositions(0)=(X=-66.0,Y=1.0,Z=145.0)
    ExitPositions(1)=(X=-66.0,Y=1.0,Z=145.0)
    ExitPositions(2)=(X=-66.0,Y=1.0,Z=145.0)
    ExitPositions(3)=(X=-87.0,Y=-156.0,Z=10.0)
    ExitPositions(4)=(X=-230.0,Y=-34.0,Z=10.0)
    ExitPositions(5)=(X=-230.0,Y=34.0,Z=10.0)
    ExitPositions(6)=(X=-87.0,Y=156.0,Z=10.0)
    DriverDamageMult=1.0
    VehicleNameString="Panzer III Ausf.M"
    MaxDesireability=1.8
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=475.0
    Health=475
    Mesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    Skins(2)=texture'axis_vehicles_tex.Treads.Panzer3_treads'
    Skins(3)=texture'axis_vehicles_tex.Treads.Panzer3_treads'
    Skins(4)=texture'axis_vehicles_tex.int_vehicles.panzer3_int'
    Skins(5)=texture'DH_VehiclesGE_tex2.ext_vehicles.gear_Stug'
    CollisionRadius=175.0
    CollisionHeight=60.0
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.panzer3_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=4
    VehicleHudOccupantsX(3)=0.375
    VehicleHudOccupantsY(3)=0.7
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.75
    VehicleHudOccupantsX(6)=0.625
    VehicleHudOccupantsY(6)=0.7
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.panzer3_l'
}
