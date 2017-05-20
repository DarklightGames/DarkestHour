//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_LocustTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Locust_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Locust_tex.utx

simulated state ViewTransition // TEMP to fake camera position changes until anims are made
{
    simulated function HandleTransition()
    {
        super(DHVehicle).HandleTransition();

        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
             if (DriverPositionIndex == 0)
                 FPCamPos = vect(19.0, -2.0, 16.0);
             else if (DriverPositionIndex == 1)
                 FPCamPos = vect(15.0, -0.5, 6.0);
             else if (DriverPositionIndex == 2)
                 FPCamPos = vect(23.0, -0.5, 6.0);
        }
    }
}

exec function SetTex(int Slot) // TEMP
{
    Switch(Slot)
    {
        case 0:
            if (Skins[Slot] == default.Skins[Slot]) Skins[Slot] = texture'DH_Locust_tex.Locust_body_ext_2048'; // 2048 slightly sharper than 1024 but acceptable
            else Skins[Slot] = default.Skins[Slot];
            break;
        case 1:
            if (Skins[Slot] == default.Skins[Slot]) Skins[Slot] = texture'DH_Locust_tex.Locust_wheels_1024'; // 1024 sharper than 512 (2048 no diff from 1024)
            else if (Skins[Slot] == texture'DH_Locust_tex.Locust_wheels_1024') Skins[Slot] = texture'DH_Locust_tex.Locust_wheels_2048';
            else Skins[Slot] = default.Skins[Slot];
            break;
        case 2:
            if (Skins[Slot] == default.Skins[Slot]) // 2048 sharper than 1024 but acceptable
            {
                Skins[Slot] = texture'DH_Locust_tex.Locust_int_2048';
                Cannon.Skins[1] = texture'DH_Locust_tex.Locust_int_2048';
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
                Skins[Slot] = texture'DH_Locust_tex.Locust_turret_ext_2048'; // no difference, except turret ring guard looks slightly different
                Cannon.Skins[0] = texture'DH_Locust_tex.Locust_turret_ext_2048';
            }
            else
            {
                Skins[Slot] = default.Skins[Slot];
                Cannon.Skins[0] = default.Skins[Slot];
            }
            break;
        case 4:
            if (Skins[Slot] == default.Skins[Slot]) Skins[Slot] = texture'DH_Locust_tex.Locust_treads_1024'; // no difference
            else Skins[Slot] = default.Skins[Slot];
            break;
    }
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M22 Locust (WIP)"
    VehicleTeam=1
    VehicleMass=5.0
    PointValue=2.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_Locust_anm.Locust_body'
    Skins(0)=texture'DH_Locust_tex.Locust_body_ext'
    Skins(1)=texture'DH_Locust_tex.Locust_wheels'
    Skins(2)=texture'DH_Locust_tex.Locust_int'
    Skins(3)=texture'DH_Locust_tex.Locust_turret_ext'
    Skins(4)=texture'DH_Locust_tex.Locust_treads'
    Skins(5)=texture'DH_Locust_tex.Locust_treads'
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc2.Locust.Locust_DriverHatch_col',AttachBone="driver_hatch") // collision attachment for driver's hatch

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_LocustCannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-80.0,Y=-40.0,Z=43.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-116.0,Y=0.0,Z=45.0),DriveRot=(Pitch=2000,Yaw=32768),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-80.0,Y=46.0,Z=43.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")

    // Driver
    DriverPositions(0)=(TransitionUpAnim="Overlay_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(1)=(TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_in",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    DrivePos=(X=16.0,Y=2.0,Z=-3.0) // TODO: reposition attachment bone to remove need for this offset, then delete this line
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
    Health=200
    HealthMax=200.0
    EngineHealth=100
    VehHitpoints(0)=(PointRadius=20.0,PointOffset=(X=-72.0,Y=13.5,Z=3.5)) // engine
    VehHitpoints(1)=(PointRadius=9.0,PointScale=1.0,PointBone="body",PointOffset=(X=-17.0,Y=0.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=49.0
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=-60.0,Y=13.5,Z=30.0)
    HullFireChance=0.45
    FireAttachBone="body"
    FireEffectOffset=(X=60.0,Y=-30.0,Z=50.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.Locust.Locust_dest' // TODO: get a proper destroyed mesh made & a new destroyed overlay 'shaped' for the treads

    // Exit
    ExitPositions(0)=(X=60.0,Y=-95.0,Z=50.0)   // driver
    ExitPositions(1)=(X=-20.0,Y=-12.0,Z=150.0) // commander
    ExitPositions(2)=(X=-75.0,Y=-110.0,Z=50.0) // riders
    ExitPositions(3)=(X=-170.0,Y=2.24,Z=50.0)
    ExitPositions(4)=(X=-75.0,Y=110.0,Z=50.0)

    // Sounds
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart.stuart_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T60.t60_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T60.t60_engine_stop'
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=sound'DH_AlliedVehicleSounds.stuart.stuart_inside_rumble'
    SoundPitch=32

    // Visual effects
    LeftTreadIndex=4
    RightTreadIndex=5
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=16384)
    TreadVelocityScale=120.0
    WheelRotationScale=45500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-53.0,Y=68.0,Z=29.0),ExhaustRotation=(Yaw=16384))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD // TODO: get 4 named HUD icons made
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.stuart_body' // locust_body
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stuart_turret_rot' // Locust_turret_rot
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stuart_turret_look' // Locust_turret_look
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
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.m5_stuart' // Locust

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
