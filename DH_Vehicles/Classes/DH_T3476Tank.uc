//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476Tank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\allies_t3476_anm.ukx
#exec OBJ LOAD FILE=..\Textures\allies_vehicles_tex.utx

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if ( LeftTreadPanner != None )
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 0, 16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }
    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if ( RightTreadPanner != None )
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(0, 0, 16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'allies_vehicles_tex.ext_vehicles.T3476_ext');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex.Treads.T3476_treads');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex.int_vehicles.T3476_int');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex.int_vehicles.t3476_int_s');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex.ext_vehicles.T3476_ext');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex.Treads.T3476_treads');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex.int_vehicles.T3476_int');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex.int_vehicles.t3476_int_s');

    Super.UpdatePrecacheMaterials();
}


defaultproperties
{
    // Display
    Mesh=Mesh'allies_t3485_anm.t3485_body_ext'

    DriveAnim=VT3476_driver_idle_close
    BeginningIdleAnim=driver_hatch_idle_close

    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.T3476_ext'
    Skins(1)=Texture'allies_vehicles_tex.Treads.T3476_treads'
    Skins(2)=Texture'allies_vehicles_tex.Treads.T3476_treads'
    Skins(3)=Texture'allies_vehicles_tex.int_vehicles.T3476_int'

    HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.t3476_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

    // Hud stuff
    VehicleHudImage=Texture'InterfaceArt_tex.Tank_Hud.T3476_body'
    VehicleHudTurret=TexRotator'InterfaceArt_tex.Tank_Hud.T3476_turret_rot'
    VehicleHudTurretLook=TexRotator'InterfaceArt_tex.Tank_Hud.T3476_turret_look'

    VehicleHudEngineX=0.51
    VehicleHudOccupantsX(0)=0.44
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsX(2)=0.56
    VehicleHudOccupantsX(3)=0.550000
    VehicleHudOccupantsX(4)=0.635000
    VehicleHudOccupantsX(5)=0.360000
    VehicleHudOccupantsX(6)=0.360000
    VehicleHudOccupantsY(3)=0.650000
    VehicleHudOccupantsY(4)=0.750000
    VehicleHudOccupantsY(5)=0.750000
    VehicleHudOccupantsY(6)=0.650000

    // Vehicle Params
    VehicleTeam=1;
    Health=525
    HealthMax=525
    DisintegrationHealth=-1000 // -900 instead of -1000 because of high health.
    CollisionHeight=+60.0
    CollisionRadius=175
    DriverDamageMult=1.0
    TreadVelocityScale=110
    MaxDesireability=2.5

    GearRatios(0)=-0.200000
    GearRatios(1)=0.200000
    GearRatios(2)=0.350000
    GearRatios(3)=0.650000
    GearRatios(4)=0.70000
    TransRatio=0.11;

    // Weapon Attachments
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_T3476CannonPawn',WeaponBone=Turret_Placement)
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_T34MountedMGPawn',WeaponBone=MG_Placement)

    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-82.0,Y=-65.0,Z=45.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-151.0,Y=-65.0,Z=45.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-151.0,Y=66.0,Z=45.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-82.0,Y=66.0,Z=45.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")

    // Position Info
    DriverAttachmentBone=driver_attachment
    DriverPositions(0)=(PositionMesh=Mesh'allies_t3485_anm.t3485_body_int',DriverTransitionAnim=Vt3485_driver_close,TransitionUpAnim=driver_hatch_open,ViewPitchUpLimit=0,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bExposed=false,ViewFOV=80,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=Mesh'allies_t3485_anm.t3485_body_int',DriverTransitionAnim=Vt3485_driver_open,TransitionDownAnim=driver_hatch_close,ViewPitchUpLimit=5500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=11000,ViewNegativeYawLimit=-12500,bExposed=true,ViewFOV=80)
    UnbuttonedPositionIndex=1
    InitialPositionIndex=0

    FPCamPos=(X=0,Y=0,Z=0)
    FPCamViewOffset=(X=0,Y=0,Z=0)
    bFPNoZFromCameraPitch=True
    TPCamLookat=(X=-50,Y=0,Z=0)
    TPCamWorldOffset=(X=0,Y=0,Z=250)
    TPCamDistance=600
    DrivePos=(X=0,Y=0,Z=0)

    // Driver overlay
    HUDOverlayClass=class'ROVehicles.T3476DriverOverlay'
    HUDOverlayOffset=(X=0,Y=0,Z=0)
    HUDOverlayFOV=85

    ExitPositions(0)=(X=0,Y=-200,Z=100)
    ExitPositions(1)=(X=0,Y=200,Z=100)
    EntryPosition=(X=0,Y=0,Z=0)
    EntryRadius=375.0

    VehicleNameString="T34/76"

    PitchUpLimit=5000
    PitchDownLimit=60000

    // Destruction
    //DD bCanThrowTurret=true
    DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.T3476_Destroyed'
    //BB DisintegrationEffectClass=Class'DH_ROEffects.DH_T3476ObliteratedEmitter'
    //BB DisintegrationEffectLowClass=Class'DH_ROEffects.DH_T3476ObliteratedEmitter_simple'
    DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
    DestructionAngularMomentum=(Min=50.000000,Max=150.000000)
    DamagedEffectOffset=(X=-100,Y=20,Z=26)
    DamagedEffectScale=0.9

    // effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-175,Y=30,Z=10),ExhaustRotation=(pitch=36000,yaw=0,roll=0))
    ExhaustPipes(1)=(ExhaustPosition=(X=-175,Y=-30,Z=10),ExhaustRotation=(pitch=36000,yaw=0,roll=0))
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'

    // sound
    IdleSound=sound'Vehicle_Engines.T34.t34_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T34.t34_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T34.t34_engine_stop'

    //Vehicle's ambient (idle) sound properties
    MaxPitchSpeed=50//450
    SoundPitch=32 //half normal pitch = 1 octave lower
    SoundRadius=2000 // 200
    TransientSoundRadius=5000 // 600
    bFullVolume=false // true

    // RO Vehicle sound vars
    LeftTreadSound=sound'Vehicle_Engines.track_squeak_L07'
    RightTreadSound=sound'Vehicle_Engines.track_squeak_L07'
    RumbleSound=sound'Vehicle_Engines.tank_inside_rumble02'
    LeftTrackSoundBone=Track_l
    RightTrackSoundBone=Track_r
    RumbleSoundBone=body

        // Wheels
    // Steering Wheels
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=True
         BoneOffset=(X=35.0,Y=-10.0,Z=2.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_LF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=True
        BoneOffset=(X=35.0,Y=10.0,Z=2.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_RF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-12.0,Y=-10.0,Z=2.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_LR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-12.0,Y=10.0,Z=2.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.RR_Steering'
     // End Steering Wheels

     // Center Drive Wheels
     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=10.0,Z=2.0)
         BoneName="Drive_Wheel_L"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=-10.0,Z=2.0)
         BoneName="Drive_Wheel_R"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.Right_Drive_Wheel'

    // Wheel bones for animation
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

     // Misc ONS
    FlagBone=MG_Placement// Probably not needed
    FlagRotation=(Yaw=32768)

    // debug
    //bDontUsePositionMesh = true;

    // Special hit points
    VehHitpoints(0)=(PointRadius=9.0,PointHeight=0.0,PointScale=1.0,PointBone=driver_player,PointOffset=(X=17.0,Y=0.0,Z=5.0),bPenetrationPoint=false,HitPointType=HP_Driver)
    VehHitpoints(1)=(PointRadius=40.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=-90.0,Y=0.0,Z=0.0),bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(2)=(PointRadius=25.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=13.0,Y=-25.0,Z=-5.0),bPenetrationPoint=false,DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=13.0,Y=25.0,Z=-5.0),bPenetrationPoint=false,DamageMultiplier=5.0,HitPointType=HP_AmmoStore)

    HullFireChance=0.55

    // Armor
    UFrontArmorFactor=4.5
    URightArmorFactor=4.5
    ULeftArmorFactor=4.5
    URearArmorFactor=4.5

    UFrontArmorSlope=60.0
    URightArmorSlope=40.0
    ULeftArmorSlope=40.0
    URearArmorSlope=45.0

    FrontLeftAngle=332.0
    FrontRightAngle=28.0
    RearRightAngle=152.0
    RearLeftAngle=208.0

    PointValue=3.000000

    TreadHitMinAngle= 1.9
    TreadDamageThreshold=0.750000

    MaxCriticalSpeed=820.0

    LeftTreadIndex=1
    RightTreadIndex=2
}
