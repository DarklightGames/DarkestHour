//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Bofors40mmCannon extends DHVehicleAutoCannon;

var     name        TraverseControlBone;
var     name        ElevationControlBone;

// New function to animate the traverse & elevation controls, called by cannon pawn when gun moves
simulated function UpdateControlsRotation()
{
    local rotator ControlRotation;

    ControlRotation.Pitch = -CurrentAim.Pitch * 32;
    SetBoneRotation(TraverseControlBone, ControlRotation);

    ControlRotation.Pitch = -CurrentAim.Yaw * 32;
    SetBoneRotation(ElevationControlBone, ControlRotation);
}

// From DHATGunCannon, as gun will always be penetrated by a shell
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector ProjectileDirection, float MaxArmorPenetration)
{
   return true;
}

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Bofors_anm.Bofors40mm_gun'
    Skins(0)=Texture'DH_Bofors_tex.Bofors40mmGun'
    Skins(1)=Texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle'

    // Turret movement
    RotationsPerSecond=0.138888 // 50 degrees per sec
    PitchUpLimit=16384
    CustomPitchUpLimit=15474 // +85/-5 degrees
    CustomPitchDownLimit=64626
    TraverseControlBone="traverse_control"
    ElevationControlBone="elevation_control"

    // Sounds (HUDProportion overrides to better suit magazine reload)
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.AAGuns.40mmBofors_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.AAGuns.40mmBofors_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.AAGuns.40mmBofors_fire03'

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Guns.DH_Bofors40mmCannonShellHE'
    SecondaryProjectileClass=class'DH_Guns.DH_Bofors40mmCannonShell'

    ProjectileDescriptions(0)="HE-T"
    ProjectileDescriptions(1)="AP"

    nProjectileDescriptions(0)="Mk.II HE-T"
    nProjectileDescriptions(1)="M81A1 AP"

    NumPrimaryMags=20
    NumSecondaryMags=20
    InitialPrimaryAmmo=8
    InitialSecondaryAmmo=8

    // Weapon fire
    FireInterval=0.5
    WeaponFireOffset=2.0
    AddedPitch=40 // results in shell hitting exactly where tip of sight is, at point blank range
}
