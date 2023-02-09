//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LocustTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Textures\DH_Locust_tex.utx

exec function SetTex(int Slot) // TEMP (incl compiler directive) to allow switching between different sized versions of the vehicle skins, to compare them & look for detail loss
{
    Switch(Slot)
    {
        case 0:
            if (Skins[Slot] == default.Skins[Slot]) Skins[Slot] = Texture'DH_Locust_tex.Locust_body_ext_2048'; // 2048 slightly sharper than 1024 but acceptable
            else Skins[Slot] = default.Skins[Slot];
            break;
        case 1:
            if (Skins[Slot] == default.Skins[Slot]) Skins[Slot] = Texture'DH_Locust_tex.Locust_wheels_1024'; // 1024 sharper than 512 (2048 no diff from 1024)
            else if (Skins[Slot] == Texture'DH_Locust_tex.Locust_wheels_1024') Skins[Slot] = Texture'DH_Locust_tex.Locust_wheels_2048';
            else Skins[Slot] = default.Skins[Slot];
            break;
        case 2:
            if (Skins[Slot] == default.Skins[Slot]) // 2048 sharper than 1024 but acceptable
            {
                Skins[Slot] = Texture'DH_Locust_tex.Locust_int_2048';
                Cannon.Skins[1] = Texture'DH_Locust_tex.Locust_int_2048';
            }
            else
            {
                Skins[Slot] = default.Skins[Slot];
                Cannon.Skins[1] = default.Skins[Slot];
            }
            break;
        case 3:
            if (Skins[Slot] == default.Skins[Slot])
            {
                Skins[Slot] = Texture'DH_Locust_tex.Locust_turret_ext_2048'; // no difference, except turret ring guard looks slightly different
                Cannon.Skins[0] = Texture'DH_Locust_tex.Locust_turret_ext_2048';
            }
            else
            {
                Skins[Slot] = default.Skins[Slot];
                Cannon.Skins[0] = default.Skins[Slot];
            }
            break;
        case 4:
            if (Skins[Slot] == default.Skins[Slot]) Skins[Slot] = Texture'DH_Locust_tex.Locust_treads_1024'; // no difference
            else Skins[Slot] = default.Skins[Slot];
            break;
    }
}

simulated state ViewTransition // TEMP to fake camera position changes until anims are made
{
    simulated function HandleTransition()
    {
        super(DHVehicle).HandleTransition();

        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
             if (DriverPositionIndex == 0)
                FPCamPos = vect(13.0, -2.75, 0.0);
             else if (DriverPositionIndex == 1) // on pericope: move 0/-1.5/+3.75 up to scope, then snap another +7/0/+5 to exterior view
                 FPCamPos = vect(0.0, -1.5, 3.75);
             else if (DriverPositionIndex == 3) // hatch open
                 FPCamPos = vect(9.0, 0.0, 0.0);
        }
    }
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M22 Locust **WIP**"
    VehicleTeam=1
    VehicleMass=8.0
    ReinforcementCost=4

    // Hull mesh
    Mesh=SkeletalMesh'DH_Locust_anm.Locust_body'
    Skins(0)=Texture'DH_Locust_tex.Locust_body_ext'
    Skins(1)=Texture'DH_Locust_tex.Locust_wheels'
    Skins(2)=Texture'DH_Locust_tex.Locust_int'
    Skins(3)=Texture'DH_Locust_tex.Locust_turret_ext'
    Skins(4)=Texture'DH_Locust_tex.Locust_treads'
    Skins(5)=Texture'DH_Locust_tex.Locust_treads'
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc2.Locust.Locust_DriverHatch_col',AttachBone="driver_hatch") // collision attachment for driver's hatch

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_LocustCannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-80.0,Y=-40.0,Z=43.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-116.0,Y=0.0,Z=45.0),DriveRot=(Pitch=2000,Yaw=32768),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-80.0,Y=46.0,Z=43.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")

    // Driver
    DriverPositions(0)=(TransitionUpAnim="driver_visor_close",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=true)
    DriverPositions(1)=(TransitionUpAnim="periscope_out",TransitionDownAnim="driver_visor_open",/*ViewPitchUpLimit=1,ViewPitchDownLimit=65535,*/ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(2)=(TransitionUpAnim="driver_hatch_open",TransitionDownAnim="periscope_in",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(3)=(TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    InitialPositionIndex=2
    UnbuttonedPositionIndex=3
    OverlayFPCamPos=(X=7.0,Y=0.0,Z=5.0)
    DriveAnim="VPanzer3_driver_idle_open" // TODO: check is most suitable anim available

    // Hull armor
    FrontArmor(0)=(Thickness=1.27,Slope=-57.0,MaxRelativeHeight=-10.9,LocationName="lower nose") // measured slope in the hull mesh
    FrontArmor(1)=(Thickness=2.54,MaxRelativeHeight=6.3,LocationName="nose")
    FrontArmor(2)=(Thickness=1.27,Slope=65.0,LocationName="upper")
    RightArmor(0)=(Thickness=1.27,MaxRelativeHeight=23.5,LocationName="lower")
    RightArmor(1)=(Thickness=0.95,Slope=45.0,LocationName="upper")
    LeftArmor(0)=(Thickness=1.27,MaxRelativeHeight=23.5,LocationName="lower")
    LeftArmor(1)=(Thickness=0.95,Slope=45.0,LocationName="upper")
    RearArmor(0)=(Thickness=1.27,Slope=-9.0)

    FrontRightAngle=30.0
    RearRightAngle=153.0
    RearLeftAngle=207.0
    FrontLeftAngle=330.0

    // Movement
    MaxCriticalSpeed=1057.0
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.14

    // Damage
	// pros: 37mm ammoracks are unlikely to explode
	// cons: 3 men crew in a tight space; petrol fuel
    Health=455
    HealthMax=455.0
	EngineHealth=300
	AmmoIgnitionProbability=0.27  // 0.75 default
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    TurretDetonationThreshold=4000.0 // increased from 1750
    VehHitpoints(0)=(PointRadius=20.0,PointOffset=(X=-72.0,Y=13.5,Z=3.5)) // engine
    VehHitpoints(1)=(PointRadius=9.0,PointScale=1.0,PointBone="body",PointOffset=(X=-17.0,Y=0.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=49.0
    DamagedTrackStaticMeshLeft=StaticMesh'DH_allies_vehicles_stc2.Locust.Locust_DamagedTrack_left'
    DamagedTrackStaticMeshRight=StaticMesh'DH_allies_vehicles_stc2.Locust.Locust_DamagedTrack_right'
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=-60.0,Y=13.5,Z=30.0)
    FireAttachBone="body"
    FireEffectOffset=(X=60.0,Y=-30.0,Z=50.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.Locust.Locust_dest' // TODO: get a proper destroyed mesh made & a new destroyed overlay texture shaped for the treads

    // Exit
    ExitPositions(0)=(X=60.0,Y=-95.0,Z=50.0)   // driver
    ExitPositions(1)=(X=-20.0,Y=-12.0,Z=150.0) // commander
    ExitPositions(2)=(X=-75.0,Y=-110.0,Z=50.0) // riders
    ExitPositions(3)=(X=-170.0,Y=2.24,Z=50.0)
    ExitPositions(4)=(X=-75.0,Y=110.0,Z=50.0)

    // Sounds
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart.stuart_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.T60.t60_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.T60.t60_engine_stop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=Sound'DH_AlliedVehicleSounds.stuart.stuart_inside_rumble'
    SoundPitch=32

    // Visual effects
    LeftTreadIndex=4
    RightTreadIndex=5
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=16384)
    TreadVelocityScale=85.0
    WheelRotationScale=45000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-53.0,Y=68.0,Z=29.0),ExhaustRotation=(Yaw=16384))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_Locust_tex.HUD.locust_body'
    VehicleHudTurret=TexRotator'DH_Locust_tex.HUD.locust_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Locust_tex.HUD.locust_turret_look'
    VehicleHudTreadsPosX(0)=0.37
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.61
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(2)=0.4
    VehicleHudOccupantsX(3)=0.5
    VehicleHudOccupantsX(4)=0.6
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(2)=0.72
    VehicleHudOccupantsY(3)=0.78
    VehicleHudOccupantsY(4)=0.72
    SpawnOverlay(0)=Material'DH_Locust_tex.HUD.locust'

    // Visible wheels
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    LeftWheelBones(7)="Wheel_L_8"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"
    RightWheelBones(7)="Wheel_R_8"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_LocustTank.LF_Steering'

    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_LocustTank.RF_Steering'

    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_LocustTank.LR_Steering'

    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_LocustTank.RR_Steering'

    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_LocustTank.Left_Drive_Wheel'

    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_LocustTank.Right_Drive_Wheel'
}
