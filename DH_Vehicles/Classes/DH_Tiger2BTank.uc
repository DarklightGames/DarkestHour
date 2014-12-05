//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Tiger2BTank extends DH_ROTreadCraftB;

#exec OBJ LOAD FILE=..\Animations\DH_Tiger2B_anm.ukx
#exec OBJ LOAD FILE=..\Sounds\DH_GerVehicleSounds2.uax
#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex2.utx
#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex3.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Tiger2B_body_normandy');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.Tiger2B_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.Tiger2B_body_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.JagdTiger_skirtdetails');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Tiger2B_body_normandy');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.Tiger2B_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.Tiger2B_body_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.JagdTiger_skirtdetails');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxCriticalSpeed=693.000000
     TreadDamageThreshold=1.000000
     PeriscopeOverlay=Texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
     UFrontArmorFactor=15.000000
     URightArmorFactor=8.000000
     ULeftArmorFactor=8.000000
     URearArmorFactor=8.000000
     UFrontArmorSlope=50.000000
     URightArmorSlope=25.000000
     ULeftArmorSlope=25.000000
     URearArmorSlope=30.000000
     PointValue=5.000000
     MaxPitchSpeed=50.000000
     TreadVelocityScale=100.000000
     LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L08'
     RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R08'
     RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'
     LeftTrackSoundBone="Wheel_L_1"
     RightTrackSoundBone="Wheel_R_1"
     RumbleSoundBone="driver_attachment"
     VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.tiger2B_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.tiger2B_turret_look'
     VehicleHudThreadsPosX(1)=0.670000
     VehicleHudThreadsPosY=0.540000
     VehicleHudThreadsScale=0.720000
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
     WheelRotationScale=2000
     TreadHitMinAngle=1.900000
     FrontLeftAngle=332.000000
     RearLeftAngle=208.000000
     GearRatios(3)=0.450000
     GearRatios(4)=0.700000
     TransRatio=0.070000
     SteerSpeed=50.000000
     SteerBoneName="Steering"
     ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
     ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-232.000000,Y=23.000000,Z=27.000000),ExhaustRotation=(Pitch=22000))
     ExhaustPipes(1)=(ExhaustPosition=(X=-232.000000,Y=-27.000000,Z=27.000000),ExhaustRotation=(Pitch=22000))
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Tiger2BCannonPawn',WeaponBone="Turret_placement")
     PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_Tiger2BMountedMGPawn',WeaponBone="Mg_placement")
     IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
     StartUpSound=Sound'Vehicle_Engines.Tiger.tiger_engine_start'
     ShutDownSound=Sound'Vehicle_Engines.Tiger.tiger_engine_stop'
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Tiger2B.Tiger2B_dest'
     DamagedEffectScale=1.250000
     DamagedEffectOffset=(X=-135.000000,Y=20.000000,Z=20.000000)
     SteeringScaleFactor=2.000000
     BeginningIdleAnim="driver_hatch_idle_close"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.000000,bDrawOverlays=true)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanther_driver_close",ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=7000,ViewNegativeYawLimit=-7000,ViewFOV=90.000000)
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanther_driver_open",ViewPitchUpLimit=15000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.000000)
     VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.tiger2B_body'
     VehicleHudOccupantsX(0)=0.440000
     VehicleHudOccupantsX(2)=0.570000
     VehicleHudOccupantsY(0)=0.350000
     VehicleHudOccupantsY(2)=0.350000
     bVehicleHudUsesLargeTexture=true
     VehHitpoints(0)=(PointOffset=(X=-3.000000),bPenetrationPoint=false)
     VehHitpoints(1)=(PointRadius=40.000000,PointOffset=(X=-115.000000,Z=-22.000000),DamageMultiplier=1.000000)
     VehHitpoints(2)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-55.000000,Y=-65.000000,Z=4.000000),DamageMultiplier=3.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(3)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-55.000000,Y=65.000000,Z=4.000000),DamageMultiplier=3.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(4)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(Y=-65.000000,Z=4.000000),DamageMultiplier=3.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(5)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(Y=65.000000,Z=4.000000),DamageMultiplier=3.000000,HitPointType=HP_AmmoStore)
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=25.000000,Y=-10.000000,Z=1.000000)
         WheelRadius=38.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=25.000000,Y=10.000000,Z=1.000000)
         WheelRadius=38.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-7.000000,Y=-10.000000,Z=1.000000)
         WheelRadius=38.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-7.000000,Y=10.000000,Z=1.000000)
         WheelRadius=38.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.RR_Steering'

     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_L"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-10.000000,Z=1.000000)
         WheelRadius=38.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=true
         bHandbrakeWheel=true
         BoneName="drive_wheel_R"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-10.000000,Z=1.000000)
         WheelRadius=38.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.Right_Drive_Wheel'

     VehicleMass=16.000000
     bFPNoZFromCameraPitch=true
     DrivePos=(X=10.000000,Y=2.000000,Z=-25.000000)
     DriveAnim="VPanther_driver_idle_close"
     ExitPositions(0)=(X=130.000000,Y=-150.000000,Z=100.000000)
     ExitPositions(1)=(X=130.000000,Y=150.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamPos=(X=0.000000,Y=-5.000000,Z=0.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-50.000000)
     TPCamWorldOffset=(Z=250.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a Panzer VI Ausf.B"
     VehicleNameString="Panzer VI Ausf.B"
     MaxDesireability=1.900000
     FlagBone="Mg_placement"
     FlagRotation=(Yaw=32768)
     HUDOverlayFOV=90.000000
     PitchUpLimit=5000
     PitchDownLimit=60000
     HealthMax=650.000000
     Health=650
     Mesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_body_ext'
     Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.tiger2B_body_normandy'
     Skins(1)=Texture'DH_VehiclesGE_tex2.Treads.tiger2B_treads'
     Skins(2)=Texture'DH_VehiclesGE_tex2.Treads.tiger2B_treads'
     Skins(3)=Texture'DH_VehiclesGE_tex2.int_vehicles.tiger2B_body_int'
     Skins(4)=Texture'DH_VehiclesGE_tex2.ext_vehicles.JagdTiger_skirtdetails'
     SoundPitch=32
     SoundRadius=5000.000000
     TransientSoundRadius=10000.000000
     CollisionRadius=175.000000
     CollisionHeight=60.000000
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(Z=-2.000000)
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=true
         bKNonSphericalInertia=true
         KMaxAngularSpeed=0.900000
         bHighDetailOnly=false
         bClientOnly=false
         bKDoubleTickRate=true
         bDestroyOnWorldPenetrate=true
         bDoSafetime=true
         KFriction=0.500000
         KImpactThreshold=700.000000
     End Object
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_Tiger2BTank.KParams0'

     HighDetailOverlay=Texture'DH_VehiclesGE_tex2.int_vehicles.tiger2B_body_int'
     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=3
}
