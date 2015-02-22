//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_UniCarrierTransport extends DH_ROTransportCraft;

#exec OBJ LOAD FILE=..\Animations\DH_allies_carrier_anm.ukx
#exec OBJ LOAD FILE=..\Textures\allies_vehicles_tex2.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx
#exec OBJ LOAD FILE=..\Sounds\Vehicle_EnginesTwo.uax

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[1];
        LeftTreadPanner.PanDirection = rot(0, 0, 16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[1] = LeftTreadPanner;
    }
    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[2];
        RightTreadPanner.PanDirection = rot(0, 0, 16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[2] = RightTreadPanner;
    }
}

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    //L.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.7thUniversalCarrier_body_ext');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex.Treads.T60_treads');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int_S');
}

simulated function UpdatePrecacheMaterials()
{
    //Level.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.7thUniversalCarrier_body_ext');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex.Treads.T60_treads');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int_S');

    super.UpdatePrecacheMaterials();
}

// Overridden to handle the special driver animations for this vehicle
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositions[DriverPositionIndex].PositionMesh != none && !bDontUsePositionMesh)
            {
                LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }
        }

        if (PreviousPositionIndex < DriverPositionIndex && HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
        {
            PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
        }
        else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
        {
            PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
        }

        if (Level.NetMode != NM_DedicatedServer && Driver != none)
        {
            if (DriverPositionIndex == InitialPositionIndex && PreviousPositionIndex < DriverPositionIndex)
            {
                Driver.PlayAnim(DriveAnim);
            }
            else if (Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }
    }
}

defaultproperties
{
    MaxPitchSpeed=125.000000
    TreadVelocityScale=80.000000
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="Wheel_T_L_3"
    RightTrackSoundBone="Wheel_T_R_3"
    RumbleSoundBone="body"
    MaxCriticalSpeed=875.000000
    LeftWheelBones(0)="Wheel_T_L_1"
    LeftWheelBones(1)="Wheel_T_L_2"
    LeftWheelBones(2)="Wheel_T_L_3"
    LeftWheelBones(3)="Wheel_T_L_4"
    LeftWheelBones(4)="Wheel_T_L_5"
    RightWheelBones(0)="Wheel_T_R_1"
    RightWheelBones(1)="Wheel_T_R_2"
    RightWheelBones(2)="Wheel_T_R_3"
    RightWheelBones(3)="Wheel_T_R_4"
    RightWheelBones(4)="Wheel_T_R_5"
    WheelRotationScale=1600
    WheelSoftness=0.025000
    WheelPenScale=2.000000
    WheelPenOffset=0.010000
    WheelRestitution=0.100000
    WheelInertia=0.100000
    WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
    WheelLongSlip=0.001000
    WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=10000000000.000000)))
    WheelLongFrictionScale=1.500000
    WheelLatFrictionScale=3.000000
    WheelHandbrakeSlip=0.010000
    WheelHandbrakeFriction=0.100000
    WheelSuspensionTravel=15.000000
    FTScale=0.030000
    ChassisTorqueScale=0.250000
    MinBrakeFriction=4.000000
    MaxSteerAngleCurve=(Points=((OutVal=35.000000),(InVal=1500.000000,OutVal=20.000000),(InVal=1000000000.000000,OutVal=15.000000)))
    TorqueCurve=(Points=((OutVal=11.000000),(InVal=200.000000,OutVal=1.250000),(InVal=1500.000000,OutVal=2.500000),(InVal=2200.000000)))
    GearRatios(0)=-0.200000
    GearRatios(1)=0.200000
    GearRatios(2)=0.350000
    GearRatios(3)=0.550000
    GearRatios(4)=0.600000
    TransRatio=0.120000
    ChangeUpPoint=2000.000000
    ChangeDownPoint=1000.000000
    LSDFactor=1.000000
    EngineBrakeFactor=0.000100
    EngineBrakeRPMScale=0.100000
    MaxBrakeTorque=20.000000
    SteerSpeed=160.000000
    TurnDamping=50.000000
    StopThreshold=100.000000
    HandbrakeThresh=200.000000
    EngineInertia=0.100000
    IdleRPM=500.000000
    EngineRPMSoundRange=5000.000000
    SteerBoneName="Steering"
    RevMeterScale=4000.000000
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-105.000000,Y=33.000000,Z=13.000000),ExhaustRotation=(Pitch=36000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-105.000000,Y=-33.000000,Z=13.000000),ExhaustRotation=(Pitch=36000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierGunPawn',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierPassengerOne',WeaponBone="passenger_l_1")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierPassengerTwo',WeaponBone="passenger_l_2")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierPassengerThree',WeaponBone="passenger_r_1")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierPassengerFour',WeaponBone="passenger_r_2")
    IdleSound=SoundGroup'Vehicle_EnginesTwo.UC.UC_engine_loop'
    StartUpSound=sound'Vehicle_EnginesTwo.UC.UC_engine_start'
    ShutDownSound=sound'Vehicle_EnginesTwo.UC.UC_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Carrier.Carrier_destroyed'
    DisintegrationHealth=-1000.000000
    DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
    DestructionAngularMomentum=(Max=150.000000)
    DamagedEffectScale=0.750000
    DamagedEffectOffset=(X=-40.000000,Y=10.000000,Z=10.000000)
    VehicleTeam=1
    SteeringScaleFactor=4.000000
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Carrier_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bExposed=true,ViewFOV=90.000000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Carrier_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VUC_driver_close",ViewPitchUpLimit=14000,ViewPitchDownLimit=58000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.000000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Carrier_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_open",ViewPitchUpLimit=14000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.000000)
    VehicleHudImage=texture'InterfaceArt2_tex.Tank_Hud.Carrier_body'
    VehicleHudOccupantsX(0)=0.580000
    VehicleHudOccupantsX(1)=0.460000
    VehicleHudOccupantsX(2)=0.390000
    VehicleHudOccupantsX(3)=0.390000
    VehicleHudOccupantsX(4)=0.620000
    VehicleHudOccupantsX(5)=0.620000
    VehicleHudOccupantsY(0)=0.350000
    VehicleHudOccupantsY(1)=0.300000
    VehicleHudOccupantsY(2)=0.500000
    VehicleHudOccupantsY(3)=0.650000
    VehicleHudOccupantsY(4)=0.500000
    VehicleHudOccupantsY(5)=0.650000
    VehicleHudEngineY=0.750000
    VehHitpoints(0)=(PointOffset=(X=-9.000000,Y=3.000000,Z=35.000000),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=20.000000,PointBone="Engine",PointOffset=(X=-15.000000),DamageMultiplier=1.000000)
    VehHitpoints(2)=(PointRadius=20.000000,PointScale=1.000000,PointBone="Engine",PointOffset=(X=22.000000),DamageMultiplier=1.000000,HitPointType=HP_Engine)
    VehHitpoints(3)=(PointRadius=15.000000,PointScale=1.000000,PointBone="Engine",PointOffset=(Z=30.000000),DamageMultiplier=1.000000,HitPointType=HP_Engine)
    VehHitpoints(4)=(PointRadius=15.000000,PointScale=1.000000,PointBone="Engine",PointOffset=(X=27.000000,Z=30.000000),DamageMultiplier=1.000000,HitPointType=HP_Engine)
    VehHitpoints(5)=(PointRadius=15.000000,PointHeight=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-83.000000,Z=30.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    EngineHealth=125
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="Wheel_T_L_3"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="Wheel_T_R_3"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.Right_Drive_Wheel'
    VehicleMass=5.000000
    bHasHandbrake=true
    DriveAnim="VUC_driver_idle_close"
    ExitPositions(0)=(X=48.00,Y=117.00,Z=15.00)
    ExitPositions(1)=(X=48.00,Y=-107.00,Z=15.00)
    ExitPositions(2)=(X=52.00,Y=-119.00,Z=13.00)
    ExitPositions(3)=(X=-45.00,Y=-118.00,Z=15.00)
    ExitPositions(4)=(X=7.00,Y=110.00,Z=15.00)
    ExitPositions(5)=(X=-48.00,Y=111.00,Z=15.00)
    EntryRadius=375.000000
    TPCamDistance=200.000000
    TPCamLookat=(X=0.000000,Z=0.000000)
    TPCamWorldOffset=(Z=50.000000)
    DriverDamageMult=1.000000
    VehicleNameString="Mk.I Bren Carrier"
    MaxDesireability=0.100000
    HUDOverlayClass=class'ROVehicles.UniCarrierDriverOverlay'
    HUDOverlayOffset=(Y=-0.800000,Z=1.990000)
    HUDOverlayFOV=81.000000
    PitchUpLimit=500
    PitchDownLimit=49000
    HealthMax=275.000000
    Health=275
    Mesh=SkeletalMesh'DH_allies_carrier_anm.Carrier_body_ext'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.7thUniversalCarrier_body_ext'
    Skins(1)=texture'allies_vehicles_tex.Treads.T60_treads'
    Skins(2)=texture'allies_vehicles_tex.Treads.T60_treads'
    Skins(3)=texture'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int'
    CollisionRadius=175.000000
    CollisionHeight=40.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Z=-0.500000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=2.000000
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.500000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_UniCarrierTransport.KParams0'
    HighDetailOverlay=Shader'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
}
