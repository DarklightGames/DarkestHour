//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Flak38Cannon extends DH_Sdkfz2341Cannon;

#exec OBJ LOAD FILE=..\Animations\DH_Flak38_anm.ukx

var     name        SightBone;
var     name        TraverseWheelBone;
var     name        ElevationWheelBone;

var class<Emitter>  ShellCaseEmitterClass;
var     Emitter     ShellCaseEmitter;

// Modified to skip over the Super in DH_Sdkfz2341Cannon, which attaches extra collision static meshes specifically for that vehicle's turret mesh covers
// Also to remove the RangeSettings array, as FlaK 38 has no range settings on the gunsight
// TODO: change inheritance by creating generic DHVehicleAutoCannon class, moving functionality from DH_Sdkfz2341Cannon, so FlaK 38 doesn't have to extend that (Matt)
simulated function PostBeginPlay()
{
    super(DHVehicleCannon).PostBeginPlay();

    RangeSettings.Length = 0;
    default.RangeSettings.Length = 0;
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

// Modified to spawn an emitter for the ejected shell cases
// Note we can't simply add a MeshEmitter to FlashEmitterClass because that's attached to barrel bone & when it recoils it messes up the ejected shell case location
simulated function InitEffects()
{
    super.InitEffects();

    if (Level.NetMode != NM_DedicatedServer && ShellCaseEmitter == none)
    {
        ShellCaseEmitter = Spawn(ShellCaseEmitterClass);

        if (ShellCaseEmitter != none)
        {
            AttachToBone(ShellCaseEmitter, PitchBone);
        }
    }
}

// Modified to trigger new shell case emitter every time we fire
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    super.FlashMuzzleFlash(bWasAltFire);

    if (ShellCaseEmitter != none)
    {
        ShellCaseEmitter.Trigger(self, Instigator);
    }
}

// From DHATGunCannon, as parent Sd.Kfz.234/1 armoured car cannon extends DHVehicleCannon (AT gun will always be penetrated by a shell)
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector ProjectileDirection, float MaxArmorPenetration)
{
   return true;
}

// Modified to add ShellCaseEmitter
simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (ShellCaseEmitter != none)
    {
        ShellCaseEmitter.Destroy();
    }
}

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret'
    Skins(0)=texture'DH_Artillery_tex.Flak38.Flak38_gun'
    Skins(1)=none
    Skins(2)=none
    Skins(3)=none
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_turret_coll'
    GunnerAttachmentBone="Turret" // this gunner doesn't move (i.e. animation pose), so we don't need a dedicated attachment bone

    // Turret movement
    RotationsPerSecond=0.05
    CustomPitchUpLimit=15474
    CustomPitchDownLimit=64990

    // Cannon ammo
    SecondaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellAP'
    TertiaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellHE'
    AltFireProjectileClass=none
    NumPrimaryMags=12
    NumSecondaryMags=4
    NumTertiaryMags=4
    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=20
    InitialTertiaryAmmo=20

    // Weapon fire
    WeaponFireOffset=5.0
    AddedPitch=50
    ShellCaseEmitterClass=class'DH_Vehicles.DH_20mmShellCaseEmitter'

    // Animations
    BeginningIdleAnim="optic_idle"
    ShootLoweredAnim="shoot_optic"
    ShootIntermediateAnim="shoot_opensight"
    ShootRaisedAnim="shoot_lookover"
    SightBone="Sight_arm"
    TraverseWheelBone="Traverse_wheel"
    ElevationWheelBone="Elevation_wheel"
}
