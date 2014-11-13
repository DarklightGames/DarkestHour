//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanTank extends DH_ROTreadCraftB;

#exec OBJ LOAD FILE=..\Animations\DH_ShermanM4A176W_anm.ukx
#exec OBJ LOAD FILE=..\Animations\DH_Sherman_anm.ukx
#exec OBJ LOAD FILE=..\textures\DH_VehiclesUS_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc.usx

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 0, -16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }
    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(0, 0, -16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

static function StaticPrecache(LevelInfo L)
{
        Super.StaticPrecache(L);

        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.Treads.M10_treads');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.Sherman76W_turret_ext');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.Treads.M10_treads');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.Sherman76W_turret_ext');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     LeftTreadIndex=5
     RightTreadIndex=4
     MaxCriticalSpeed=638.000000
     TreadDamageThreshold=0.750000
     HullFireChance=0.450000
     UFrontArmorFactor=5.100000
     URightArmorFactor=3.800000
     ULeftArmorFactor=3.800000
     URearArmorFactor=3.800000
     UFrontArmorSlope=55.000000
     PointValue=3.000000
     MaxPitchSpeed=150.000000
     TreadVelocityScale=110.000000
     LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
     RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
     RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
     LeftTrackSoundBone="Track_L"
     RightTrackSoundBone="Track_R"
     RumbleSoundBone="Camera_driver"
     VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman_turret_look'
     VehicleHudThreadsPosY=0.510000
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
     WheelRotationScale=2200
     TreadHitMinAngle=1.300000
     FrontLeftAngle=335.000000
     FrontRightAngle=25.000000
     RearRightAngle=155.000000
     RearLeftAngle=205.000000
     GearRatios(4)=0.720000
     TransRatio=0.100000
     SteerBoneName="Steering"
     LeftLeverBoneName="lever_L"
     LeftLeverAxis=AXIS_Z
     RightLeverBoneName="lever_R"
     RightLeverAxis=AXIS_Z
     ExhaustEffectClass=Class'ROEffects.ExhaustPetrolEffect'
     ExhaustEffectLowClass=Class'ROEffects.ExhaustPetrolEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-116.000000,Z=35.000000),ExhaustRotation=(Pitch=31000,Yaw=-16384))
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_ShermanCannonPawn',WeaponBone="Turret_placement")
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_ShermanMountedMGPawn_M4A176W',WeaponBone="Mg_placement")
     PassengerWeapons(2)=(WeaponPawnClass=Class'DH_Vehicles.DH_ShermanPassengerOne',WeaponBone="Passenger_1")
     PassengerWeapons(3)=(WeaponPawnClass=Class'DH_Vehicles.DH_ShermanPassengerTwo',WeaponBone="passenger_2")
     PassengerWeapons(4)=(WeaponPawnClass=Class'DH_Vehicles.DH_ShermanPassengerThree',WeaponBone="passenger_3")
     PassengerWeapons(5)=(WeaponPawnClass=Class'DH_Vehicles.DH_ShermanPassengerFour',WeaponBone="passenger_4")
     IdleSound=SoundGroup'DH_AlliedVehicleSounds.Sherman.ShermanEngineLoop'
     StartUpSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanStart'
     ShutDownSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanStop'
     DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Sherman_Dest'
     DamagedEffectScale=0.900000
     DamagedEffectOffset=(X=-113.000000,Y=20.000000,Z=79.000000)
     VehicleTeam=1
     SteeringScaleFactor=0.750000
     BeginningIdleAnim="driver_hatch_idle_close"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_intA',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.000000,bDrawOverlays=true)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_intA',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanzer4_driver_close",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.000000)
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_intA',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanzer4_driver_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.000000)
     VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.Sherman_body'
     VehicleHudOccupantsX(0)=0.430000
     VehicleHudOccupantsX(2)=0.560000
     VehicleHudOccupantsX(3)=0.375
     VehicleHudOccupantsY(3)=0.75
     VehicleHudOccupantsX(4)=0.45
     VehicleHudOccupantsY(4)=0.8
     VehicleHudOccupantsX(5)=0.55
     VehicleHudOccupantsY(5)=0.8
     VehicleHudOccupantsX(6)=0.625
     VehicleHudOccupantsY(6)=0.75
     VehicleHudEngineX=0.510000
     VehHitpoints(0)=(PointOffset=(X=-6.000000),bPenetrationPoint=false)
     VehHitpoints(1)=(PointRadius=30.000000,PointOffset=(X=-90.000000,Z=60.000000),DamageMultiplier=1.000000)
     VehHitpoints(2)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-15.000000,Y=40.000000,Z=87.000000),DamageMultiplier=4.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(3)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-15.000000,Y=-40.000000,Z=87.000000),DamageMultiplier=4.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(4)=(PointRadius=25.000000,PointScale=1.000000,PointBone="body",PointOffset=(Z=55.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=20.000000,Z=12.000000)
         WheelRadius=33.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ShermanTank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=20.000000,Z=12.000000)
         WheelRadius=33.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ShermanTank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-30.000000,Z=12.000000)
         WheelRadius=33.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ShermanTank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-30.000000,Z=12.000000)
         WheelRadius=33.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ShermanTank.RR_Steering'

     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_L"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Z=12.000000)
         WheelRadius=33.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_ShermanTank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_R"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Z=12.000000)
         WheelRadius=33.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_ShermanTank.Right_Drive_Wheel'

     VehicleMass=13.500000
     bFPNoZFromCameraPitch=true
     DrivePos=(X=5.000000,Y=0.000000,Z=3.000000)
     ExitPositions(0)=(X=98.000000,Y=-40.000000,Z=156.000000)
     ExitPositions(1)=(X=98.000000,Y=10.000000,Z=156.000000)
     EntryRadius=375.000000
     FPCamPos=(X=120.000000,Y=-21.000000,Z=17.000000)
     TPCamDistance=600.000000
     TPCamLookat=(X=-50.000000)
     TPCamWorldOffset=(Z=250.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a M4A1 Sherman"
     VehicleNameString="M4A1 Sherman"
     MaxDesireability=1.900000
     FlagBone="Mg_placement"
     FlagRotation=(Yaw=32768)
     HUDOverlayOffset=(X=5.000000)
     HUDOverlayFOV=90.000000
     PitchUpLimit=5000
     PitchDownLimit=60000
     HealthMax=525.000000
     Health=525
     Mesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_extA'
     Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext'
     Skins(1)=Texture'DH_VehiclesUS_tex.ext_vehicles.Sherman76w_turret_ext'
     Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int'
     Skins(3)=Texture'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int'
     Skins(4)=Texture'DH_VehiclesUS_tex.Treads.M10_treads'
     Skins(5)=Texture'DH_VehiclesUS_tex.Treads.M10_treads'
     SoundRadius=800.000000
     TransientSoundRadius=1500.000000
     CollisionRadius=175.000000
     CollisionHeight=60.000000
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(Z=-0.400000)
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
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_ShermanTank.KParams0'

}
