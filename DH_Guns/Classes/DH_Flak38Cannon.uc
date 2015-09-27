//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Cannon extends DH_Sdkfz2341Cannon;

#exec OBJ LOAD FILE=..\Animations\DH_Flak38_anm.ukx

var     name        SightBone;
var     name        TraverseWheelBone;
var     name        ElevationWheelBone;

// Modified to skip over the Super in DH_Sdkfz2341Cannon, which attaches extra collision static meshes specifically for that vehicle's turret mesh covers
simulated function PostBeginPlay()
{
    super(DHVehicleCannon).PostBeginPlay();
}

// New function to update sight & aiming wheel rotation, called by cannon pawn when gun moves
simulated function UpdateSightAndWheelRotation()
{
    local rotator SightRotation, ElevationWheelRotation, TraverseWheelRotation;

    SightRotation.Pitch = -CurrentAim.Pitch;
    SetBoneRotation(SightBone, SightRotation);

    ElevationWheelRotation.Pitch = -CurrentAim.Pitch * 32;
    SetBoneRotation(ElevationWheelBone, ElevationWheelRotation);

    TraverseWheelRotation.Yaw = -CurrentAim.Yaw * 32;
    SetBoneRotation(TraverseWheelBone, TraverseWheelRotation);
}

// Added the following functions from DHATGunCannon, as parent Sd.Kfz.234/1 armoured car cannon extends DHVehicleCannon:
simulated function bool DHShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
   return true;
}

defaultproperties
{
    NumMags=12
    NumSecMags=4
    NumTertMags=4
    AddedPitch=50
    WeaponFireOffset=15.0
    RotationsPerSecond=0.05
    FireInterval=0.15
    FlashEmitterClass=class'DH_Guns.DH_Flak38MuzzleFlash'
    ProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed'
    AltFireProjectileClass=none
    CustomPitchUpLimit=15474
    CustomPitchDownLimit=64990
    PrimaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed'
    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=20
    InitialTertiaryAmmo=20
    SecondaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellAP'
    TertiaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellHE'
    BeginningIdleAnim="optic_idle_in"
    TankShootClosedAnim="shoot_optic"
    ShootIntermediateAnim="shoot_opensight"
    TankShootOpenAnim="shoot_lookover"
    GunnerAttachmentBone="Turret" // this gunner doesn't move (i.e. animation pose), so we don't need a dedicated attachment bone
    SightBone="Sight_arm"
    TraverseWheelBone="Traverse_wheel"
    ElevationWheelBone="Elevation_wheel"
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret'
    Skins(0)=texture'DH_Artillery_tex.Flak38.Flak38_gun'
    CollisionStaticMesh=none
}
