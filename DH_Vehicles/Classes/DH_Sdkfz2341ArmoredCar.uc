//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2341ArmoredCar extends DH_ArmoredWheeledVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Sdkfz234ArmoredCar_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex6.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc3.usx

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_dunk');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_accessories');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.int_vehicles.sdkfz2341_body_int');
}

simulated function UpdatePrecacheMaterials()
{

    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_dunk');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_accessories');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.int_vehicles.sdkfz2341_body_int');

    Super.UpdatePrecacheMaterials();
}

simulated function UpdateTurretReferences()
{
    local int i;

    if (CannonTurret == none)
    {
        for (i = 0; i < WeaponPawns.length; i++)
        {
            if (WeaponPawns[i].Gun.IsA('ROTankCannon'))
            {
                CannonTurret = ROTankCannon(WeaponPawns[i].Gun);
                break;
            }
        }
    }

    if (HullMG == none)
    {
        for (i = 0; i < WeaponPawns.length; i++)
        {
            if (WeaponPawns[i].Gun.IsA('ROMountedTankMG'))
            {
                HullMG = WeaponPawns[i].Gun;
                break;
            }
        }
    }
}

defaultproperties
{
     bSpecialExiting=true
     MaxCriticalSpeed=1039.000000
     EngineHealthMax=100
     UFrontArmorFactor=3.000000
     URightArmorFactor=0.800000
     ULeftArmorFactor=0.800000
     URearArmorFactor=0.800000
     UFrontArmorSlope=40.000000
     VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.2341_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.2341_turret_look'
     FrontLeftAngle=338.000000
     FrontRightAngle=22.000000
     RearRightAngle=158.000000
     RearLeftAngle=202.000000
     WheelPenScale=1.200000
     WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
     WheelLongFrictionScale=1.100000
     WheelLatFrictionScale=1.550000
     WheelSuspensionTravel=10.000000
     WheelSuspensionMaxRenderTravel=5.000000
     ChassisTorqueScale=0.095000
     MaxSteerAngleCurve=(Points=((OutVal=45.000000),(InVal=300.000000,OutVal=30.000000),(InVal=500.000000,OutVal=20.000000),(InVal=600.000000,OutVal=15.000000),(InVal=1000000000.000000,OutVal=10.000000)))
     GearRatios(0)=-0.350000
     GearRatios(3)=0.600000
     GearRatios(4)=0.750000
     TransRatio=0.130000
     ChangeUpPoint=1990.000000
     ChangeDownPoint=1000.000000
     SteerSpeed=75.000000
     TurnDamping=100.000000
     SteerBoneName="Steer_Wheel"
     ExhaustEffectClass=Class'ROEffects.ExhaustPetrolEffect'
     ExhaustEffectLowClass=Class'ROEffects.ExhaustPetrolEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-230.000000,Y=-68.000000,Z=45.000000),ExhaustRotation=(Pitch=36000))
     ExhaustPipes(1)=(ExhaustPosition=(X=-230.000000,Y=69.000000,Z=45.000000),ExhaustRotation=(Pitch=36000))
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Sdkfz2341CannonPawn',WeaponBone="Turret_placement")
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_Sdkfz234PassengerOne',WeaponBone="body")
     IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
     StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
     ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.234.234_dest'
     DisintegrationHealth=-100000.000000
     DamagedEffectScale=0.800000
     DamagedEffectOffset=(X=-150.000000,Y=0.000000,Z=65.000000)
     SteeringScaleFactor=4.000000
     BeginningIdleAnim="driver_hatch_idle_close"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=2730,ViewPitchDownLimit=60065,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500,ViewFOV=90.000000)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VBA64_driver_close",ViewPitchUpLimit=2730,ViewPitchDownLimit=60065,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,ViewFOV=90.000000)
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VBA64_driver_open",ViewPitchUpLimit=9500,ViewPitchDownLimit=62835,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,bExposed=true,ViewFOV=90.000000)
     VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.234_body'
     VehicleHudOccupantsX(0)=0.480000
     VehicleHudOccupantsX(2)=0.000000
     VehicleHudOccupantsY(0)=0.320000
     VehicleHudOccupantsY(1)=0.430000
     VehicleHudOccupantsY(2)=0.000000
     VehicleHudEngineX=0.510000
     VehHitpoints(0)=(PointOffset=(X=5.000000,Z=-5.000000),bPenetrationPoint=false)
     VehHitpoints(1)=(PointOffset=(X=-150.000000,Z=52.000000),DamageMultiplier=1.000000)
     VehHitpoints(2)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=30.000000,Y=-30.000000,Z=52.000000),DamageMultiplier=3.000000,HitPointType=HP_AmmoStore)
     EngineHealth=100
     bIsApc=true
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=RFWheel
         SteerType=VST_Steered
         BoneName="wheel_FR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=11.000000)
         WheelRadius=32.000000
         SupportBoneName="Axel_RF"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.RFWheel'

     Begin Object Class=SVehicleWheel Name=LFWheel
         SteerType=VST_Steered
         BoneName="wheel_FL"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-11.000000)
         WheelRadius=32.000000
         SupportBoneName="Axel_LF"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.LFWheel'

     Begin Object Class=SVehicleWheel Name=MFRWheel
         bPoweredWheel=true
         BoneName="Wheel_R_1"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=11.000000)
         WheelRadius=32.000000
         SupportBoneName="Axel_R_1"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.MFRWheel'

     Begin Object Class=SVehicleWheel Name=MFLWheel
         bPoweredWheel=true
         BoneName="Wheel_L_1"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-11.000000)
         WheelRadius=32.000000
         SupportBoneName="Axel_L_1"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.MFLWheel'

     Begin Object Class=SVehicleWheel Name=MRRWheel
         bPoweredWheel=true
         BoneName="Wheel_R_2"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=11.000000)
         WheelRadius=32.000000
         SupportBoneName="Axel_R_2"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.MRRWheel'

     Begin Object Class=SVehicleWheel Name=MRLWheel
         bPoweredWheel=true
         BoneName="Wheel_L_2"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-11.000000)
         WheelRadius=32.000000
         SupportBoneName="Axel_R_2"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.MRLWheel'

     Begin Object Class=SVehicleWheel Name=RRWheel
         bPoweredWheel=true
         BoneName="wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=11.000000)
         WheelRadius=32.000000
         SupportBoneName="Axel_RR"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(6)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.RRWheel'

     Begin Object Class=SVehicleWheel Name=RLWheel
         bPoweredWheel=true
         BoneName="Wheel_RL"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-11.000000)
         WheelRadius=32.000000
         SupportBoneName="Axel_LR"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(7)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.RLWheel'

     VehicleMass=5.000000
     DrivePos=(X=4.000000,Y=-2.000000,Z=0.000000)
     DriveAnim="VBA64_driver_idle_close"
     ExitPositions(0)=(Y=-200.000000,Z=100.000000)
     ExitPositions(1)=(Y=200.000000,Z=100.000000)
     ExitPositions(2)=(Y=-200.000000,Z=100.000000)
     ExitPositions(3)=(Y=200.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamPos=(X=42.000000,Y=-18.000000,Z=33.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a Sdkfz 234/1 Armored Car"
     VehicleNameString="Sdkfz 234/1 Armored Car"
     MaxDesireability=0.100000
     HUDOverlayOffset=(X=2.000000)
     HUDOverlayFOV=90.000000
     PitchUpLimit=500
     PitchDownLimit=58000
     Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_ext'
     Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk'
     Skins(1)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_dunk'
     Skins(2)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk'
     Skins(3)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_accessories'
     Skins(4)=Texture'DH_VehiclesGE_tex6.int_vehicles.sdkfz2341_body_int'
     SoundRadius=800.000000
     TransientSoundRadius=1500.000000
     CollisionRadius=175.000000
     CollisionHeight=60.000000
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.300000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(X=0.300000,Z=-0.525000)
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=true
         bKNonSphericalInertia=true
         bHighDetailOnly=false
         bClientOnly=false
         bKDoubleTickRate=true
         bDestroyOnWorldPenetrate=true
         bDoSafetime=true
         KFriction=0.500000
         KImpactThreshold=700.000000
     End Object
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz2341ArmoredCar.KParams0'

     HighDetailOverlayIndex=4
}
