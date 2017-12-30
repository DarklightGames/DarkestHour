//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Bofors40mmCannon extends DHVehicleAutoCannon;

#exec OBJ LOAD FILE=..\Animations\DH_Bofors_anm.ukx

var     name        SightBone;
var     name        TraverseWheelBone;
var     name        ElevationWheelBone;

// New function to update sight & aiming wheel rotation, called by cannon pawn when gun moves
simulated function UpdateSightAndWheelRotation()
{
    local rotator SightRotation, ElevationWheelRotation, TraverseWheelRotation;

    SightRotation.Pitch = -CurrentAim.Pitch;
    SetBoneRotation(SightBone, SightRotation);

    ElevationWheelRotation.Pitch = -CurrentAim.Pitch * 32;
    SetBoneRotation(ElevationWheelBone, ElevationWheelRotation);

    TraverseWheelRotation.Pitch = -CurrentAim.Yaw * 32;
    SetBoneRotation(TraverseWheelBone, TraverseWheelRotation);
}

// From DHATGunCannon, as gun will always be penetrated by a shell
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector ProjectileDirection, float MaxArmorPenetration)
{
   return true;
}

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Bofors_anm.bofors_turret'
    Skins(0)=Texture'DH_Bofors_tex.bofors.bofors_01'
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_turret_coll'  // TODO: replace
    GunnerAttachmentBone="driver_placement" // this gunner doesn't move (i.e. animation pose), so we don't need a dedicated attachment bone

    // asdad
    FireInterval=0.5
    ShellCaseEjectorBone="ejector"

    // Turret movement
    RotationsPerSecond=0.05
    CustomPitchUpLimit=15474
    CustomPitchDownLimit=64990
    PitchUpLimit=16384

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_GreyhoundCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_GreyhoundCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_GreyhoundCannonShellHE'
    ProjectileDescriptions(0)="AP"
    NumPrimaryMags=15
    NumSecondaryMags=15
    NumTertiaryMags=15
    InitialPrimaryAmmo=10
    InitialSecondaryAmmo=10
    InitialTertiaryAmmo=10

    // Weapon fire
    WeaponFireOffset=5.0
    AddedPitch=50
    ShellCaseEmitterClass=class'DH_Guns.DH_20mmShellCaseEmitter'    // TODO: replace this

    // Animations
    BeginningIdleAnim="optic_idle"
    ShootLoweredAnim="shoot_optic"
    ShootIntermediateAnim="shoot_opensight"
    ShootRaisedAnim="shoot_lookover"
    SightBone="Sight_arm"
    TraverseWheelBone="yaw_wheel"
    ElevationWheelBone="pitch_wheel"
}

