//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HetzerDestroyer extends DH_ROTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Hetzer_anm_V1.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Hetzer_tex_V1.utx
#exec OBJ LOAD FILE=..\Textures\axis_vehicles_tex.utx // Matt: for the treads
#exec OBJ LOAD FILE=..\Textures\VegetationSMT.utx // Matt: for the bushes added as extra camo
#exec OBJ LOAD FILE=..\StaticMeshes\DH_Hetzer_stc_V1.usx

static function StaticPrecache(LevelInfo L)
{
    super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treads');
    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Alpha');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treads');
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Alpha');

    Super(ROTreadCraft).UpdatePrecacheMaterials();
}

// Matt: modified to play BeginningIdleAnim on internal mesh when entering vehicle - necessary to get camera into correct place for initial DriverPosition 1
simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
        if( DriverPositions[InitialPositionIndex].PositionMesh != none) // Matt: updated to use DriverPositions[InitialPositionIndex] instead of DriverPositions[0]
            LinkMesh(DriverPositions[InitialPositionIndex].PositionMesh);

        if( HasAnim(BeginningIdleAnim)) // Matt: added to play BeginningIdleAnim when entering vehicle and we switch to the internal mesh (similar to ROVehicleWeaponPawn)
            PlayAnim(BeginningIdleAnim);

        if( PlayerController(Controller) != none )
            PlayerController(Controller).SetFOV( DriverPositions[InitialPositionIndex].ViewFOV );
    }
}

// Matt: modified to prevent tank crew from 'teleporting' outside to rider positions
function ServerChangeDriverPosition(byte F)
{
    if( F > 3 ) // Matt: if trying to switch to vehicle position 4 or 5, which are the rider positions
    {
        Instigator.ReceiveLocalizedMessage(class'DH_HetzerVehicleMessage', 0); // "You must exit through the commander's or loader's hatch"
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// Matt: modified to play a different message if trying to exit from the driver's position (can exit from loader's hatch as well as commander's)
function bool KDriverLeave(bool bForceLeave)
{
    // if player is not unbuttoned and is trying to exit rather than switch positions, don't let them out
    // bForceLeave is always true for position switch, so checking against false means no risk of locking someone in one slot
    if( !bForceLeave && !bSpecialExiting && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')) )
    {
        DenyEntry(Instigator, 4); // I realise that this is actually denying EXIT, but the function does the exact same thing - Ch!cken
        return false;
    }
    else if ( !bForceLeave && bSpecialExiting )
    {
        Instigator.ReceiveLocalizedMessage(class'DH_HetzerVehicleMessage', 0); // Matt: now says "You must exit through the commander's or loader's hatch"
        return false;
    }
    else
        return super(ROWheeledVehicle).KDriverLeave(bForceLeave); // Matt: skipping over the Super in DH_ROTreadcraft
}

defaultproperties
{
    NewVehHitpoints(0)=(PointRadius=3.200000,PointScale=1.000000,PointBone="body",PointOffset=(X=29.200001,Y=-9.040000,Z=58.000000),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=40.799999,Y=16.000000,Z=32.000000),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=40.799999,Y=16.000000,Z=32.000000),NewHitPointType=NHP_GunPitch)
    bIsAssaultGun=true
    bSpecialExiting=true
    MaxCriticalSpeed=730.000000
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    UFrontArmorFactor=6.000000
    URightArmorFactor=2.000000
    ULeftArmorFactor=2.000000
    URearArmorFactor=2.000000
    UFrontArmorSlope=60.000000
    URightArmorSlope=40.000000
    ULeftArmorSlope=40.000000
    URearArmorSlope=15.000000
    GunMantletArmorFactor=6.000000
    GunMantletSlope=40.000000
    PointValue=3.000000
    MaxPitchSpeed=450.000000
    TreadVelocityScale=110.000000
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_look'
    VehicleHudThreadsPosX(0)=0.370000
    VehicleHudThreadsPosY=0.510000
    VehicleHudThreadsScale=0.660000
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
    WheelRotationScale=2200
    TreadHitMinAngle=1.800000
    FrontLeftAngle=321.549988
    FrontRightAngle=23.809999
    RearRightAngle=166.289993
    RearLeftAngle=211.789993
    GearRatios(4)=0.720000
    TransRatio=0.100000
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-135.000000,Y=-20.000000,Z=25.000000),ExhaustRotation=(Pitch=34000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerMountedMGPawn',WeaponBone="Mg_placement")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerPassengerTwo',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_Hetzer_stc_V1.hetzer_dest_generic'
    DamagedEffectScale=0.900000
    DamagedEffectOffset=(X=-100.000000,Y=20.000000,Z=26.000000)
    SteeringScaleFactor=0.750000
    BeginningIdleAnim="Overlay_Idle"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewFOV=80.000000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_body_int',TransitionDownAnim="Overlay_In",ViewPitchUpLimit=2730,ViewPitchDownLimit=61900,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=80.000000)
    VehicleHudImage=Texture'DH_Hetzer_tex_V1.Hetzer_HUDoverlay'
    VehicleHudOccupantsX(0)=0.450000
    VehicleHudOccupantsX(1)=0.510000
    VehicleHudOccupantsX(2)=0.450000
    VehicleHudOccupantsY(2)=0.450000
    VehicleHudEngineX=0.450000
    VehHitpoints(0)=(PointRadius=1.800000,PointOffset=(X=-12.000000,Z=-4.000000),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=30.000000,PointOffset=(X=-68.000000),DamageMultiplier=1.000000)
    VehHitpoints(2)=(PointRadius=16.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=28.000000,Y=-20.000000,Z=4.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=12.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=11.200000,Y=36.000000,Z=24.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=12.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-11.200000,Y=36.000000,Z=24.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.000000)
        WheelRadius=30.000000
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.000000)
        WheelRadius=30.000000
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.000000)
        WheelRadius=30.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.000000)
        WheelRadius=30.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.Right_Drive_Wheel'
    VehicleMass=11.000000
    bDrawDriverInTP=false
    bFPNoZFromCameraPitch=true
    DriveAnim="VStug3_driver_idle_close"
    EntryRadius=375.000000
    TPCamDistance=600.000000
    TPCamLookat=(X=-50.000000)
    TPCamWorldOffset=(Z=250.000000)
    DriverDamageMult=1.000000
    VehiclePositionString="in a Hetzer"
    VehicleNameString="Jagdpanzer 38(t) Hetzer"
    MaxDesireability=1.900000
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    HUDOverlayFOV=85.000000
    HealthMax=500.000000
    Health=500
    Mesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_body_ext'
    Skins(0)=Texture'DH_Hetzer_tex_V1.hetzer_body'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Stug3_treads'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Stug3_treads'
    Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    Skins(4)=Texture'DH_Hetzer_tex_V1.hetzer_int'
    Skins(5)=Texture'DH_Hetzer_tex_V1.Hetzer_driver_glass'
    SoundRadius=800.000000
    TransientSoundRadius=1500.000000
    CollisionRadius=175.000000
    CollisionHeight=60.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Y=0.500000,Z=-0.500000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.600000
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.500000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_HetzerDestroyer.KParams0'
}
