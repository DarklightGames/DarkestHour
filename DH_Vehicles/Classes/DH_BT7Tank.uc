//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BT7Tank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="BT-7"
    VehicleTeam=1
    ReinforcementCost=3
    VehicleMass=7.0

    // Hull mesh
    Mesh=Mesh'DH_BT7_anm.bt7_body_ext'
    Skins(0)=Texture'allies_ahz_vehicles_tex.ext_vehicles.BT7_ext'
    Skins(1)=Texture'allies_ahz_vehicles_tex.Treads.bt7_treads'
    Skins(2)=Texture'allies_ahz_vehicles_tex.Treads.bt7_treads'
    Skins(3)=Texture'allies_ahz_vehicles_tex.int_vehicles.BT7_int'

    HighDetailOverlay=Material'allies_ahz_vehicles_tex.int_vehicles.BT7_Int'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

    // Collision
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc3.BT7.BT7_visor_Coll',AttachBone="hatch_driver") // collision attachment for driver's armoured visor

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_BT7CannonPawn',WeaponBone="Turret_Placement")

    PassengerPawns(0)=(AttachBone=passenger_01,DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone=passenger_02,DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(2)=(AttachBone=passenger_03,DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone=passenger_04,DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    InitialPositionIndex=1
    UnbuttonedPositionIndex=2
    DriverAttachmentBone=driver_attachment
    DriverPositions(0)=(PositionMesh=Mesh'DH_BT7_anm.BT7_body_int',DriverTransitionAnim=none,TransitionUpAnim=Overlay_Out,ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bExposed=false,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=Mesh'DH_BT7_anm.BT7_body_int',DriverTransitionAnim=VT60_driver_close,TransitionUpAnim=driver_hatch_open,TransitionDownAnim=Overlay_In,ViewPitchUpLimit=2730,ViewPitchDownLimit=61923,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=false)
    DriverPositions(2)=(PositionMesh=Mesh'DH_BT7_anm.BT7_body_int',DriverTransitionAnim=VT60_driver_open,TransitionDownAnim=driver_hatch_close,ViewPitchUpLimit=2730,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500,bExposed=true)

    FPCamPos=(X=4.0,Y=0,Z=0)
    DrivePos=(X=35,Y=0,Z=-5)

    //Driver's hatch overlay
    HUDOverlayClass=none //class'ROVehicles.KV1DriverOverlay'
    //HUDOverlayOffset=(X=2.0)
    //HUDOverlayFOV=90.0

    // Hull armor
    FrontArmor(0)=(Thickness=2.0,Slope=0.0,MaxRelativeHeight=-21.5,LocationName="lower nose") // the nose is rounded, so we do it in two parts - one flat and one slightly sloped
    FrontArmor(1)=(Thickness=2.0,Slope=10.0,MaxRelativeHeight=-11.0,LocationName="upper nose")
    FrontArmor(2)=(Thickness=1.5,Slope=60.0,MaxRelativeHeight=0.0,LocationName="glacis")
    FrontArmor(3)=(Thickness=2.0,Slope=18.0,MaxRelativeHeight=0.0,LocationName="driver's plate")
    RightArmor(0)=(Thickness=1.5,Slope=0.0,LocationName="lower")
    LeftArmor(0)=(Thickness=1.5,Slope=0.0,LocationName="lower")
    RearArmor(0)=(Thickness=1.3,Slope=-58.0,MaxRelativeHeight=-30.0,LocationName="lower")
    RearArmor(1)=(Thickness=1.3,Slope=-10.0,MaxRelativeHeight=7.7,LocationName="middle")
    RearArmor(2)=(Thickness=1.0,Slope=55.0,LocationName="upper")

    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    MaxCriticalSpeed=1200.0 // very approximate, not sure about it
    GearRatios(3)=0.67
    GearRatios(4)=0.80
    GearRatios(0)=-0.25
    TransRatio=0.13

    // Damage
    // pros: 45mm ammorack is less likely to detonate (was an important factor in T-70 survivability and recoverability)
    // cons:
    //- 3 men crew, who are quite close to each other
    //- petrol fuel
    Health=380
    HealthMax=380.0
    EngineHealth=300
    AmmoIgnitionProbability=0.33  // 0.75 default
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    TurretDetonationThreshold=3000.0 // increased from 1750
    VehHitpoints(0)=(PointRadius=28.0,PointOffset=(X=-73.0,Z=-5.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=30,Y=0,Z=10.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=28,Y=-45.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=28,Y=45.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=-3.25
    TreadDamageThreshold=0.15
    DamagedEffectOffset=(X=-78.0,Y=0.0,Z=25.0)
    FireAttachBone="turret_placement" // we don't need a driver hatch fire since the tank is so tiny. Just spawn a fire right in the middle!

    // Destroyed mesh
    bUsesCodedDestroyedSkins=false
    DestroyedVehicleMesh=StaticMesh'allies_ahz_vehicles_stc.BT7_destroyed'
    DestroyedMeshSkins(0)=Texture'allies_ahz_destroyed_vehicles_tex.BT7.destroyed_texture'

    // Exit positions
    ExitPositions(0)=(X=100.0,Y=-30.0,Z=175.0) // driver hatch
    ExitPositions(1)=(X=0.0,Y=0.0,Z=225.0)     // commander hatch

    ExitPositions(3)=(X=-75.0,Y=-125.0,Z=75.0) // left
    ExitPositions(4)=(X=-200.0,Y=2.24,Z=75.0)  // rear
    ExitPositions(5)=(X=-75.0,Y=125.0,Z=75.0)  // right
    ExitPositions(6)=(X=200.0,Y=0.0,Z=75.0)    // front

    // Sounds
    //SoundPitch=32 // half normal pitch = 1 octave lower
    MaxPitchSpeed=350
    IdleSound=SoundGroup'DH_CC_Vehicle_Sounds.engine_sounds.BT7_petrol_loop'
    StartUpSound=Sound'DH_CC_Vehicle_Sounds.engine_sounds.BT7_petrol_start'
    ShutDownSound=Sound'DH_CC_Vehicle_Sounds.engine_sounds.BT7_petrol_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'

    // Visual effects
    TreadVelocityScale=250.0
    WheelRotationScale=100000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-185,Y=23,Z=48),ExhaustRotation=(pitch=34000,yaw=0,roll=0))
    ExhaustPipes(1)=(ExhaustPosition=(X=-185,Y=-23,Z=48),ExhaustRotation=(pitch=34000,yaw=0,roll=0))
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'

    // HUD
    VehicleHudImage=Texture 'DH_InterfaceArt_tex.Tank_Hud.BT7_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.BT7_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.BT7_turret_look'
    VehicleHudTreadsPosX(0)=0.38
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.52
    VehicleHudTreadsScale=0.55     //size of tank on HUD
    VehicleHudEngineX=0.511
    VehicleHudEngineY=0.66
    VehicleHudOccupantsX(0)=0.50   //horizontal, driver            X = Left/Right
    VehicleHudOccupantsY(0)=0.26    //vertical, driver              Y = Front/Back
    VehicleHudOccupantsX(1)=0.47   //horizontal, gunner
    VehicleHudOccupantsY(1)=0.50    //vertical, gunner
    VehicleHudOccupantsX(2)=0.635   //0.34    //horizontal, passenger one
    VehicleHudOccupantsY(2)=0.65    //0.65    //vertical, passenger one
    VehicleHudOccupantsX(3)=0.635   //0.34    //horizontal, passenger two
    VehicleHudOccupantsY(3)=0.75    //0.75    //vertical, passenger two
    VehicleHudOccupantsX(4)=0.36    //0.65    //horizontal, passenger three
    VehicleHudOccupantsY(4)=0.75    //0.65    //vertical, passenger three
    VehicleHudOccupantsX(5)=0.36    //0.65    //horizontal, passenger four
    VehicleHudOccupantsY(5)=0.65    //0.75    //vertical, passenger four

    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.bt7'

    // Visible wheels
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"

    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"

    // Physics wheels
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=True
         BoneOffset=(X=35.0,Y=-7.0,Z=5.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_LF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=True
        BoneOffset=(X=35.0,Y=7.0,Z=5.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_RF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-25.0,Y=-7.0,Z=5.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_LR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-25.0,Y=7.0,Z=5.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.RR_Steering'
     // End Steering Wheels

     //-------------------------------------------------------------------------

     // Center Drive Wheels
     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=5.0,Y=7.0,Z=5.0)
         BoneName="Drive_Wheel_L"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=5.0,Y=-7.0,Z=5.0)
         BoneName="Drive_Wheel_R"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.Right_Drive_Wheel'
}
