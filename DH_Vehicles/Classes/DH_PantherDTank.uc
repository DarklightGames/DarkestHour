//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PantherDTank extends DH_ROTreadCraftB;

#exec OBJ LOAD FILE=..\Animations\axis_pantherg_anm.ukx

struct SchurzenType
{
var  class<DH_VehicleDecoAttachment>  SchurzenClass; // a possible schurzen decorative attachment class, with different degrees of damage
var  byte                             PercentChance; // the % chance of this deco attachment being the one spawned
};

var  SchurzenType              SchurzenTypes[4]; // an array of possible schurzen attachments
var  byte                      SchurzenIndex;    // the schurzen index number selected randomly to be spawned for this vehicle
var  DH_VehicleDecoAttachment  Schurzen;         // actor reference to the schurzen deco attachment, so it can be destroyed when the vehicle gets destroyed
var  vector                    SchurzenOffset;   // the positional offset from the attachment bone
var  Material                  SchurzenTexture;  // the camo skin for the schurzen attachment

replication
{
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        SchurzenIndex;
}

// Modified to assign the schuzen deco attachment class as a random selection for each vehicle spawned
simulated function PostBeginPlay()
{
    local  byte  RandomNumber, CumulativeChance, i;

    super.PostBeginPlay();

    if (Role == ROLE_Authority && SchurzenTexture != none)
    {
        RandomNumber = RAND(100);
        
        for (i = 0; i < ArrayCount(SchurzenTypes); i++)
        {
            CumulativeChance += SchurzenTypes[i].PercentChance;

            if (RandomNumber < CumulativeChance)
            {
                SchurzenIndex = i;
                break;
            }
        }
    }
}

// Modified to attach schurzen to vehicle (in multi-player this only happens clientside & only after the chosen SchurzenIndex has been replicated)
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    // Only spawn schurzen if a valid attachment class has been selected
    if (Level.NetMode != NM_DedicatedServer && SchurzenIndex < ArrayCount(SchurzenTypes) && SchurzenTypes[SchurzenIndex].SchurzenClass != none && SchurzenTexture != none)
    {
        Schurzen = Spawn(SchurzenTypes[SchurzenIndex].SchurzenClass);

        if (Schurzen != none)
        {
            Schurzen.Skins[0] = SchurzenTexture; // set the deco attachment's camo skin
            AttachToBone(Schurzen,'body');
            Schurzen.SetRelativeLocation(SchurzenOffset);
        }
    }
}

// Modified to destroy schurzen when the vehicle gets destroyed
simulated event DestroyAppearance()
{
    super.DestroyAppearance();

    if (Schurzen != none)
    {
        Schurzen.Destroy();
    }
}

// Modified to destroy schurzen when the vehicle gets destroyed
simulated function Destroyed()
{
    super.Destroyed();

    if (Schurzen != none)
    {
        Schurzen.Destroy();
    }
}

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
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'axis_vehicles_tex.ext_vehicles.pantherg_ext');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.PantherG_treads');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.pantherg_int');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.pantherg_int_s');
    L.AddPrecacheMaterial(default.SchurzenTexture);
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.ext_vehicles.pantherg_ext');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.PantherG_treads');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.pantherg_int');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.pantherg_int_s');
    Level.AddPrecacheMaterial(SchurzenTexture); 

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
	SchurzenTexture=none // Matt: we don't have a schurzen skin for this camo variant, so add here if one gets made
	SchurzenTypes(0)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenOne',PercentChance=30)   // undamaged schurzen
	SchurzenTypes(1)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenTwo',PercentChance=15)   // missing front panel on right & middle panel on left
	SchurzenTypes(2)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenThree',PercentChance=10) // with front panels missing on both sides
	SchurzenTypes(3)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenFour',PercentChance=15)  // most badly damaged, with 3 panels missing
	SchurzenOffset=(X=45.5,Y=7.45,Z=-1.0)
	SchurzenIndex=255 // invalid starting value just so if schurzen no. zero is selected, it gets actively set & so flagged for replication

     UnbuttonedPositionIndex=1
     MaxCriticalSpeed=932.000000
     TreadDamageThreshold=0.850000
     PeriscopeOverlay=Texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
     UFrontArmorFactor=8.500000
     URightArmorFactor=4.000000
     ULeftArmorFactor=4.000000
     URearArmorFactor=4.000000
     UFrontArmorSlope=55.000000
     URightArmorSlope=40.000000
     ULeftArmorSlope=40.000000
     URearArmorSlope=30.000000
     PointValue=4.000000
     MaxPitchSpeed=100.000000
     TreadVelocityScale=225.000000
     LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L05'
     RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R05'
     RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'
     LeftTrackSoundBone="Track_L"
     RightTrackSoundBone="Track_R"
     RumbleSoundBone="driver_attachment"
     VehicleHudTurret=TexRotator'InterfaceArt_tex.Tank_Hud.panther_turret_rot'
     VehicleHudTurretLook=TexRotator'InterfaceArt_tex.Tank_Hud.panther_turret_look'
     VehicleHudThreadsPosX(0)=0.380000
     VehicleHudThreadsPosX(1)=0.630000
     VehicleHudThreadsPosY=0.490000
     VehicleHudThreadsScale=0.610000
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
     WheelRotationScale=2500
     TreadHitMinAngle=1.700000
     FrontLeftAngle=334.000000
     FrontRightAngle=26.000000
     RearRightAngle=154.000000
     RearLeftAngle=206.000000
     GearRatios(4)=0.800000
     TransRatio=0.110000
     ChangeUpPoint=1990.000000
     ChangeDownPoint=1000.000000
     ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
     ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-230.000000,Y=20.000000,Z=65.000000),ExhaustRotation=(Pitch=22000))
     ExhaustPipes(1)=(ExhaustPosition=(X=-230.000000,Y=-20.000000,Z=65.000000),ExhaustRotation=(Pitch=22000))
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherDCannonPawn',WeaponBone="Turret_placement")
     PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherMountedMGPawn',WeaponBone="Mg_placement")
     PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherPassengerOne',WeaponBone="body")
     PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherPassengerTwo',WeaponBone="body")
     PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherPassengerThree',WeaponBone="body")
     PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherPassengerFour',WeaponBone="body")
     IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
     StartUpSound=Sound'Vehicle_Engines.Tiger.tiger_engine_start'
     ShutDownSound=Sound'Vehicle_Engines.Tiger.tiger_engine_stop'
     DestroyedVehicleMesh=StaticMesh'axis_vehicles_stc.PantherG.PantherG_Destoyed'
     DamagedEffectOffset=(X=-100.000000,Y=20.000000,Z=26.000000)
     BeginningIdleAnim="driver_hatch_idle_close"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_body_int',TransitionUpAnim="driver_hatch_open",DriverTransitionAnim="VPanther_driver_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.000000,bDrawOverlays=true)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanther_driver_open",ViewPitchUpLimit=8000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.000000)

     InitialPositionIndex=0
     VehicleHudImage=Texture'InterfaceArt_tex.Tank_Hud.panther_body'

     VehicleHudOccupantsX(0)=0.450000
     VehicleHudOccupantsY(0)=0.380000
     VehicleHudOccupantsX(2)=0.550000
     VehicleHudOccupantsY(2)=0.380000
     VehicleHudOccupantsX(3)=0.400000
     VehicleHudOccupantsY(3)=0.690000
     VehicleHudOccupantsX(4)=0.400000
     VehicleHudOccupantsY(4)=0.790000
     VehicleHudOccupantsX(5)=0.605000
     VehicleHudOccupantsY(5)=0.790000
     VehicleHudOccupantsX(6)=0.605000
     VehicleHudOccupantsY(6)=0.690000

     VehHitpoints(0)=(PointRadius=10.000000,PointBone="body",PointOffset=(X=100.000000,Y=-30.000000,Z=61.000000),bPenetrationPoint=false)
     VehHitpoints(1)=(PointRadius=32.000000,PointHeight=35.000000,PointOffset=(X=-90.000000,Z=6.000000),DamageMultiplier=1.000000)
     VehHitpoints(2)=(PointRadius=15.000000,PointHeight=30.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=20.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(3)=(PointRadius=15.000000,PointHeight=10.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-20.000000,Y=-40.000000,Z=40.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(4)=(PointRadius=15.000000,PointHeight=10.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-20.000000,Y=40.000000,Z=40.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=32.000000,Y=-15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=32.000000,Y=15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-14.000000,Y=-15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-14.000000,Y=15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.RR_Steering'

     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_L"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=true
         bHandbrakeWheel=true
         BoneName="drive_wheel_R"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.Right_Drive_Wheel'

     VehicleMass=14.000000
     bTurnInPlace=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=0.000000,Y=0.000000,Z=0.000000)
     DriveAnim="VPanther_driver_idle_close"
     ExitPositions(0)=(Y=-200.000000,Z=100.000000)
     ExitPositions(1)=(Y=200.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamPos=(X=120.000000,Y=-21.000000,Z=17.000000)
     TPCamDistance=600.000000
     TPCamLookat=(X=-50.000000)
     TPCamWorldOffset=(Z=250.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a Panzer V Ausf.D"
     VehicleNameString="Panzer V Ausf.D"
     MaxDesireability=2.100000
     FlagBone="Mg_placement"
     FlagRotation=(Yaw=32768)
     HUDOverlayFOV=90.000000
     PitchUpLimit=5000
     PitchDownLimit=60000
     HealthMax=600.000000
     Health=600
     Mesh=SkeletalMesh'axis_pantherg_anm.PantherG_body_ext'
     Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.pantherg_ext'
     Skins(1)=Texture'axis_vehicles_tex.Treads.PantherG_treads'
     Skins(2)=Texture'axis_vehicles_tex.Treads.PantherG_treads'
     Skins(3)=Texture'axis_vehicles_tex.int_vehicles.pantherg_int'
     SoundPitch=32
     SoundRadius=2500.000000
     TransientSoundRadius=5000.000000
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
         KMaxAngularSpeed=1.000000
         bHighDetailOnly=false
         bClientOnly=false
         bKDoubleTickRate=true
         bDestroyOnWorldPenetrate=true
         bDoSafetime=true
         KFriction=0.500000
         KImpactThreshold=700.000000
     End Object
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_PantherDTank.KParams0'

     HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.pantherg_int_s'
     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=3
}
