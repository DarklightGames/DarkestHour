//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIIINTank extends DH_ROTreadCraftB;

#exec OBJ LOAD FILE=..\Animations\DH_Panzer3_anm.ukx
#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex2.utx

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 32768, 16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }
    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(32768, 0, 16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

static function StaticPrecache(LevelInfo L)
{
    super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.alpha');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Panzer3_treads');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int_s');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.alpha');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Panzer3_treads');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int_s');

    super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
     UnbuttonedPositionIndex=1
     bSpecialExiting=true
     LeftTreadIndex=2
     RightTreadIndex=3
     MaxCriticalSpeed=729.000000
     FireAttachBone="Player_Driver"
     PeriscopeOverlay=Texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
     UFrontArmorFactor=7.200000
     URightArmorFactor=3.000000
     ULeftArmorFactor=3.000000
     URearArmorFactor=5.000000
     UFrontArmorSlope=9.000000
     URearArmorSlope=9.000000
     PointValue=3.000000
     MaxPitchSpeed=150.000000
     TreadVelocityScale=225.000000
     LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L01'
     RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R01'
     RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble01'
     LeftTrackSoundBone="Track_L"
     RightTrackSoundBone="Track_R"
     RumbleSoundBone="body"
     VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3n_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3n_turret_look'
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
     TreadHitMinAngle=1.800000
     FrontLeftAngle=330.000000
     FrontRightAngle=30.000000
     RearRightAngle=150.000000
     RearLeftAngle=210.000000
     GearRatios(4)=0.650000
     LeftLeverBoneName="lever_L"
     LeftLeverAxis=AXIS_Z
     RightLeverBoneName="lever_R"
     RightLeverAxis=AXIS_Z
     ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
     ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-175.000000,Y=-52.000000,Z=55.000000),ExhaustRotation=(Pitch=22000))
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIINCannonPawn',WeaponBone="Turret_placement")
     PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIIMountedMGPawn',WeaponBone="Mg_placement")
     PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIIPassengerOne',WeaponBone="body")
     PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIIPassengerTwo',WeaponBone="body")
     PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIIPassengerThree',WeaponBone="body")
     PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIIPassengerFour',WeaponBone="body")
     IdleSound=SoundGroup'Vehicle_Engines.Panzeriii.PanzerIII_engine_loop'
     StartUpSound=Sound'Vehicle_Engines.Panzeriii.PanzerIII_engine_start'
     ShutDownSound=Sound'Vehicle_Engines.Panzeriii.PanzerIII_engine_stop'
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3n_destroyed2'
     DamagedEffectScale=0.850000
     DamagedEffectOffset=(X=-100.000000,Y=20.000000,Z=26.000000)
     SteeringScaleFactor=0.750000
     BeginningIdleAnim="periscope_idle_out"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_body_int',TransitionUpAnim="periscope_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65536,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,ViewFOV=70.000000,bDrawOverlays=true)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_body_int',TransitionUpAnim="Overlay_In",TransitionDownAnim="Periscope_in",DriverTransitionAnim="VPanzer3_driver_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.000000)
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_body_int',TransitionDownAnim="Overlay_Out",ViewPitchUpLimit=6000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.000000)
     VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.panzer3n_body'
     VehHitpoints(0)=(PointRadius=10.000000,PointBone="body",PointOffset=(X=85.000000,Y=-27.000000,Z=30.000000),bPenetrationPoint=false)
     VehHitpoints(1)=(PointRadius=30.000000,PointHeight=32.000000,PointOffset=(X=-70.000000,Z=6.000000),DamageMultiplier=1.000000)
     VehHitpoints(2)=(PointRadius=10.000000,PointHeight=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=50.000000,Y=-25.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(3)=(PointRadius=10.000000,PointHeight=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=50.000000,Y=25.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(4)=(PointRadius=15.000000,PointHeight=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-30.000000,Y=25.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=40.000000,Y=-5.000000,Z=7.000000)
         WheelRadius=30.000000
     End Object
     Wheels(0)=SVehicleWheel'ROVehicles.PanzerIIITank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=40.000000,Y=5.000000,Z=7.000000)
         WheelRadius=30.000000
     End Object
     Wheels(1)=SVehicleWheel'ROVehicles.PanzerIIITank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-5.000000,Y=-5.000000,Z=7.000000)
         WheelRadius=30.000000
     End Object
     Wheels(2)=SVehicleWheel'ROVehicles.PanzerIIITank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-5.000000,Y=5.000000,Z=7.000000)
         WheelRadius=30.000000
     End Object
     Wheels(3)=SVehicleWheel'ROVehicles.PanzerIIITank.RR_Steering'

     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_L"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=10.000000,Z=7.000000)
         WheelRadius=30.000000
     End Object
     Wheels(4)=SVehicleWheel'ROVehicles.PanzerIIITank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_R"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=10.000000,Z=7.000000)
         WheelRadius=30.000000
     End Object
     Wheels(5)=SVehicleWheel'ROVehicles.PanzerIIITank.Right_Drive_Wheel'

     VehicleMass=11.500000
     bDrawDriverInTP=false
     bFPNoZFromCameraPitch=true
     DrivePos=(X=0.000000,Y=0.000000,Z=0.000000)
     DriveAnim="VPanzer3_driver_idle_close"
     ExitPositions(0)=(Y=-200.000000,Z=100.000000)
     ExitPositions(1)=(Y=200.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamPos=(X=0.000000,Y=0.000000,Z=0.000000)
     TPCamDistance=600.000000
     TPCamLookat=(X=-50.000000)
     TPCamWorldOffset=(Z=250.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a Panzer III Ausf.N"
     VehicleNameString="Panzer III Ausf.N"
     MaxDesireability=1.800000
     FlagBone="Mg_placement"
     FlagRotation=(Yaw=32768)
     HUDOverlayOffset=(X=2.000000)
     HUDOverlayFOV=90.000000
     PitchUpLimit=5000
     PitchDownLimit=60000
     HealthMax=475.000000
     Health=475
     Mesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_body_ext'
     Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
     Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
     Skins(2)=Texture'axis_vehicles_tex.Treads.Panzer3_treads'
     Skins(3)=Texture'axis_vehicles_tex.Treads.Panzer3_treads'
     Skins(4)=Texture'axis_vehicles_tex.int_vehicles.panzer3_int'
     SoundRadius=800.000000
     TransientSoundRadius=1500.000000
     CollisionRadius=175.000000
     CollisionHeight=60.000000
     HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.panzer3_int_s'
     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=4
     VehicleHudOccupantsX(3)=0.375
     VehicleHudOccupantsY(3)=0.70
     VehicleHudOccupantsX(4)=0.45
     VehicleHudOccupantsY(4)=0.75
     VehicleHudOccupantsX(5)=0.55
     VehicleHudOccupantsY(5)=0.75
     VehicleHudOccupantsX(6)=0.625
     VehicleHudOccupantsY(6)=0.70
}
