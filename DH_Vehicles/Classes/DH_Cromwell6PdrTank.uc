//==============================================================================
// DH_Cromwell6PdrTank
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British Cruiser Tank Mk.VIII Cromwell Mk.I
//==============================================================================
class DH_Cromwell6PdrTank extends DH_ROTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Cromwell_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 0, 0);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }

    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(0, 0, 0);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Cromwell_body_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Cromwell_armor_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.treads.Cromwell_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.int_vehicles.Cromwell_body_int2');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.int_vehicles.Cromwell_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Cromwell_body_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Cromwell_armor_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.treads.Cromwell_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.int_vehicles.Cromwell_body_int2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.int_vehicles.Cromwell_body_int');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     UnbuttonedPositionIndex=1
     LeftTreadIndex=3
     MaxCriticalSpeed=1165.000000
     TreadDamageThreshold=0.750000
     UFrontArmorFactor=6.300000
     URightArmorFactor=3.200000
     ULeftArmorFactor=3.200000
     URearArmorFactor=3.200000
     PointValue=3.000000
     MaxPitchSpeed=150.000000
     TreadVelocityScale=78.000000
     LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
     RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
     RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'
     LeftTrackSoundBone="Track_L"
     RightTrackSoundBone="Track_R"
     RumbleSoundBone="body"
     VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_Rot'
     VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_Look'
     VehicleHudThreadsPosX(0)=0.370000
     VehicleHudThreadsPosY=0.480000
     VehicleHudThreadsScale=0.700000
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
     WheelRotationScale=250
     TreadHitMinAngle=1.160000
     FrontRightAngle=27.000000
     RearRightAngle=153.000000
     GearRatios(3)=0.600000
     GearRatios(4)=0.800000
     TransRatio=0.140000
     SteerBoneName="Steering"
     LeftLeverBoneName="lever_L"
     LeftLeverAxis=AXIS_Z
     RightLeverBoneName="lever_R"
     RightLeverAxis=AXIS_Z
     ExhaustEffectClass=Class'ROEffects.ExhaustPetrolEffect'
     ExhaustEffectLowClass=Class'ROEffects.ExhaustPetrolEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-175.000000,Y=30.000000,Z=10.000000),ExhaustRotation=(Pitch=36000))
     ExhaustPipes(1)=(ExhaustPosition=(X=-175.000000,Y=-30.000000,Z=10.000000),ExhaustRotation=(Pitch=36000))
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Cromwell6PdrCannonPawn',WeaponBone="Turret_placement")
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_CromwellMountedMGPawn',WeaponBone="Mg_attachment")
     IdleSound=SoundGroup'Vehicle_Engines.T34.t34_engine_loop'
     StartUpSound=Sound'Vehicle_Engines.T34.t34_engine_start'
     ShutDownSound=Sound'Vehicle_Engines.T34.t34_engine_stop'
     DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Crommy_wrecked'
     DamagedEffectScale=0.900000
     DamagedEffectOffset=(X=-130.000000,Y=20.000000,Z=72.000000)
     VehicleTeam=1
     SteeringScaleFactor=0.750000
     BeginningIdleAnim="driver_hatch_idle_close"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_int',TransitionUpAnim="driver_hatch_open",DriverTransitionAnim="VUC_driver_idle_close",ViewPitchDownLimit=65535,ViewFOV=85.000000,bDrawOverlays=true)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_idle_close",ViewPitchUpLimit=5500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=11000,ViewNegativeYawLimit=-12500,bExposed=true,ViewFOV=85.000000)
     InitialPositionIndex=0
     VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.cromwell_body'
     VehicleHudOccupantsX(0)=0.560000
     VehicleHudOccupantsX(1)=0.520000
     VehicleHudOccupantsX(2)=0.460000
     VehicleHudEngineX=0.510000
     VehHitpoints(0)=(PointBone="body",PointOffset=(X=128.000000,Y=27.000000,Z=25.000000),bPenetrationPoint=false)
     VehHitpoints(1)=(PointRadius=35.000000,PointOffset=(X=-95.000000,Z=2.000000),DamageMultiplier=1.000000)
     VehHitpoints(2)=(PointRadius=25.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-20.000000,Y=40.000000,Z=3.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(3)=(PointRadius=25.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-20.000000,Y=-40.000000,Z=3.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(4)=(PointRadius=25.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=40.000000,Z=-8.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=35.000000,Y=-10.000000,Z=2.000000)
         WheelRadius=33.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=35.000000,Y=10.000000,Z=2.000000)
         WheelRadius=33.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-12.000000,Y=-10.000000,Z=2.000000)
         WheelRadius=33.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-12.000000,Y=10.000000,Z=2.000000)
         WheelRadius=33.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.RR_Steering'

     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_L"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=10.000000,Z=2.000000)
         WheelRadius=33.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_R"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-10.000000,Z=2.000000)
         WheelRadius=33.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.Right_Drive_Wheel'

     VehicleMass=13.000000
     bFPNoZFromCameraPitch=true
     DrivePos=(X=-2.000000,Y=-5.000000,Z=2.000000)
     DriveAnim="VUC_driver_idle_close"
     ExitPositions(0)=(X=100.000000,Y=150.000000,Z=156.000000)
     ExitPositions(1)=(Y=150.000000,Z=156.000000)
     EntryRadius=375.000000
     FPCamPos=(X=120.000000,Y=-21.000000,Z=17.000000)
     TPCamDistance=600.000000
     TPCamLookat=(X=-50.000000)
     TPCamWorldOffset=(Z=250.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a Cromwell Mk.I"
     VehicleNameString="Cromwell Mk.I"
     MaxDesireability=1.900000
     FlagBone="Mg_placement"
     FlagRotation=(Yaw=32768)
     HUDOverlayClass=Class'ROVehicles.KV1DriverOverlay'
     HUDOverlayOffset=(X=-1.000000)
     HUDOverlayFOV=85.000000
     PitchUpLimit=5000
     PitchDownLimit=60000
     HealthMax=525.000000
     Health=525
     Mesh=SkeletalMesh'DH_Cromwell_anm.cromwell_body6pdr_ext'
     Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_body_ext'
     Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_armor_ext'
     Skins(2)=Texture'DH_VehiclesUK_tex.Treads.Cromwell_treads'
     Skins(3)=Texture'DH_VehiclesUK_tex.Treads.Cromwell_treads'
     Skins(4)=Texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int2'
     Skins(5)=Texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int'
     SoundRadius=800.000000
     TransientSoundRadius=1500.000000
     CollisionRadius=175.000000
     CollisionHeight=60.000000
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(Z=-0.600000)
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
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_Cromwell6PdrTank.KParams0'

}
