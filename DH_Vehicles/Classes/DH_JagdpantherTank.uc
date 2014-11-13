//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpantherTank extends DH_ROTreadCraftB;

#exec OBJ LOAD FILE=..\Animations\DH_Jagdpanther_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

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

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.jagdpanther_body_goodwood');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.jagdpanther_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_walls_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_body_int');
    L.AddPrecacheMaterial(default.SchurzenTexture);
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.jagdpanther_body_goodwood');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.jagdpanther_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_walls_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_body_int');
    Level.AddPrecacheMaterial(SchurzenTexture); 

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
	SchurzenTexture=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo2' // ideally get better matching texture made, but for now this is passable match
	SchurzenTypes(0)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenOne',PercentChance=30)   // undamaged schurzen
	SchurzenTypes(1)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenTwo',PercentChance=15)   // missing front panel on right & middle panel on left
	SchurzenTypes(2)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenThree',PercentChance=10) // with front panels missing on both sides
	SchurzenTypes(3)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenFour',PercentChance=15)  // most badly damaged, with 3 panels missing
	SchurzenOffset=(X=28.4,Y=5.8,Z=-14.2)
	SchurzenIndex=255 // invalid starting value just so if schurzen no. zero is selected, it gets actively set & so flagged for replication

     NewVehHitpoints(0)=(PointRadius=8.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=55.000000,Y=-40.000000,Z=77.000000),NewHitPointType=NHP_GunOptics)
     NewVehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="Turret_placement",PointOffset=(X=72.000000,Z=45.000000),NewHitPointType=NHP_Traverse)
     NewVehHitpoints(2)=(PointRadius=15.000000,PointScale=1.000000,PointBone="Turret_placement",PointOffset=(X=72.000000,Z=45.000000),NewHitPointType=NHP_GunPitch)
     bIsAssaultGun=true
     UnbuttonedPositionIndex=1
     bSpecialExiting=true
     LeftTreadIndex=2
     RightTreadIndex=1
     MaxCriticalSpeed=1002.000000
     TreadDamageThreshold=0.850000
     FireEffectOffset=(X=-15.000000)
     PeriscopeOverlay=Texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
     UFrontArmorFactor=8.200000
     URightArmorFactor=5.000000
     ULeftArmorFactor=5.000000
     URearArmorFactor=4.000000
     UFrontArmorSlope=55.000000
     URightArmorSlope=30.000000
     ULeftArmorSlope=30.000000
     URearArmorSlope=25.000000
     GunMantletSlope=35.000000
     PointValue=4.000000
     MaxPitchSpeed=80.000000
     TreadVelocityScale=225.000000
     LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L05'
     RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R05'
     RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'
     LeftTrackSoundBone="Wheel_L_1"
     RightTrackSoundBone="Wheel_R_1"
     RumbleSoundBone="body"
     VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_turret_look'
     VehicleHudThreadsPosX(0)=0.380000
     VehicleHudThreadsPosX(1)=0.630000
     VehicleHudThreadsPosY=0.540000
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
     WheelRotationScale=2200
     TreadHitMinAngle=1.500000
     FrontRightAngle=27.000000
     RearRightAngle=153.000000
     GearRatios(4)=0.800000
     TransRatio=0.100000
     ChangeUpPoint=1990.000000
     ChangeDownPoint=1000.000000
     ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
     ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-230.000000,Y=20.000000,Z=109.592003),ExhaustRotation=(Pitch=22000))
     ExhaustPipes(1)=(ExhaustPosition=(X=-230.000000,Y=-20.000000,Z=109.592003),ExhaustRotation=(Pitch=22000))
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherCannonPawn',WeaponBone="Turret_placement")
     PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherMountedMGPawn',WeaponBone="Mg_attachment")
     IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
     StartUpSound=Sound'Vehicle_Engines.Tiger.tiger_engine_start'
     ShutDownSound=Sound'Vehicle_Engines.Tiger.tiger_engine_stop'
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Jagdpanther.Jagdpanther_dest'
     DamagedEffectScale=1.100000
     DamagedEffectOffset=(X=-135.000000,Y=20.000000,Z=108.000000)
     BeginningIdleAnim="driver_hatch_idle_close"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,ViewFOV=90.000000,bDrawOverlays=true)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_int',TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanther_driver_close",ViewPitchUpLimit=2300,ViewPitchDownLimit=64000,ViewPositiveYawLimit=7000,ViewNegativeYawLimit=-7000,ViewFOV=90.000000)
     VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_body'
     VehicleHudOccupantsX(0)=0.430000
     VehicleHudOccupantsX(1)=0.550000
     VehicleHudOccupantsX(2)=0.590000
     VehicleHudOccupantsY(0)=0.380000
     VehicleHudOccupantsY(1)=0.510000
     VehicleHudOccupantsY(2)=0.380000
     VehicleHudEngineX=0.510000
     VehHitpoints(0)=(PointBone="body",PointOffset=(X=100.000000,Y=-40.000000,Z=30.000000),bPenetrationPoint=false)
     VehHitpoints(1)=(PointRadius=32.000000,PointHeight=35.000000,PointOffset=(X=-122.000000,Z=-6.000000),DamageMultiplier=1.000000)
     VehHitpoints(2)=(PointRadius=15.000000,PointHeight=10.000000,PointScale=1.000000,PointBone="body",PointOffset=(Y=-45.000000,Z=50.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(3)=(PointRadius=15.000000,PointHeight=10.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=35.000000,Y=-45.000000,Z=50.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(4)=(PointRadius=15.000000,PointHeight=10.000000,PointScale=1.000000,PointBone="body",PointOffset=(Y=45.000000,Z=50.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(5)=(PointRadius=15.000000,PointHeight=10.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=35.000000,Y=45.000000,Z=50.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=32.000000,Y=-15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(0)=SVehicleWheel'ROVehicles.PantherTank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=true
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=32.000000,Y=15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(1)=SVehicleWheel'ROVehicles.PantherTank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-14.000000,Y=-15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(2)=SVehicleWheel'ROVehicles.PantherTank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=true
         SteerType=VST_Inverted
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-14.000000,Y=15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(3)=SVehicleWheel'ROVehicles.PantherTank.RR_Steering'

     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=true
         BoneName="drive_wheel_L"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(4)=SVehicleWheel'ROVehicles.PantherTank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=true
         bHandbrakeWheel=true
         BoneName="drive_wheel_R"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=15.000000,Z=-1.000000)
         WheelRadius=33.000000
     End Object
     Wheels(5)=SVehicleWheel'ROVehicles.PantherTank.Right_Drive_Wheel'

     VehicleMass=14.000000
     bDrawDriverInTP=false
     bFPNoZFromCameraPitch=true
     DrivePos=(X=0.000000,Y=0.000000,Z=0.000000)
     DriveAnim="VPanther_driver_idle_close"
     ExitPositions(0)=(X=-125.000000,Y=-50.000000,Z=175.000000)
     ExitPositions(1)=(X=-125.000000,Y=50.000000,Z=175.000000)
     EntryRadius=375.000000
     FPCamPos=(X=120.000000,Y=-21.000000,Z=17.000000)
     TPCamDistance=600.000000
     TPCamLookat=(X=-50.000000)
     TPCamWorldOffset=(Z=250.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a Jagdpanzer V"
     VehicleNameString="Jagdpanzer V"
     MaxDesireability=1.900000
     FlagBone="Mg_placement"
     FlagRotation=(Yaw=32768)
     HUDOverlayFOV=90.000000
     PitchUpLimit=5000
     PitchDownLimit=60000
     HealthMax=600.000000
     Health=600
     Mesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_ext'
     Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_goodwood'
     Skins(1)=Texture'DH_VehiclesGE_tex2.Treads.Jagdpanther_treads'
     Skins(2)=Texture'DH_VehiclesGE_tex2.Treads.Jagdpanther_treads'
     Skins(3)=Texture'DH_VehiclesGE_tex2.int_vehicles.Jagdpanther_walls_int'
     Skins(4)=Texture'DH_VehiclesGE_tex2.int_vehicles.Jagdpanther_body_int'
     SoundPitch=32
     SoundRadius=800.000000
     TransientSoundRadius=1500.000000
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
         KMaxAngularSpeed=0.850000
         bHighDetailOnly=false
         bClientOnly=false
         bKDoubleTickRate=true
         bDestroyOnWorldPenetrate=true
         bDoSafetime=true
         KFriction=0.500000
         KImpactThreshold=700.000000
     End Object
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_JagdpantherTank.KParams0'

}
