//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
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
simulated function PostBeginPlay()
{
    super(DHVehicleCannon).PostBeginPlay();

    RangeSettings.Length = 0;
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
simulated function bool DHShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
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
    NumMags=12
    NumSecMags=4
    NumTertMags=4
    AddedPitch=50
    WeaponFireOffset=5.0
    RotationsPerSecond=0.05
    FireInterval=0.15
    AltFireProjectileClass=none
    CustomPitchUpLimit=15474
    CustomPitchDownLimit=64990
    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=20
    InitialTertiaryAmmo=20
    SecondaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellAP'
    TertiaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellHE'
    ShellCaseEmitterClass=class'DH_Guns.DH_20mmShellCaseEmitter'
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
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_turret_coll'
}
