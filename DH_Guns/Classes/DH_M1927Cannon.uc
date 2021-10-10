//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M1927Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M1927_anm.m1927_turret'
    Skins(0)=Texture'DH_M1927_tex.world.m1927_body'
    GunnerAttachmentBone="com_player"

    // Animation
    ShootIntermediateAnim="shoot_close"

    WeaponFireAttachmentBone="Muzzle"

    // Turret movement
    RotationsPerSecond=0.005
    MaxPositiveYaw=546.0
    MaxNegativeYaw=-546.0
    YawStartConstraint=-1092.0
    YawEndConstraint=1092.0
    CustomPitchUpLimit=4550 // +25 degrees
    CustomPitchDownLimit=64444 // -6 degrees

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"

    nProjectileDescriptions(0)="OF-350"
    nProjectileDescriptions(1)="BP-350M"

    ProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'
    PrimaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'
    SecondaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHEAT'
    InitialPrimaryAmmo=6
    InitialSecondaryAmmo=4
    MaxPrimaryAmmo=6
    MaxSecondaryAmmo=4
    Spread=0.020
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=0
    AddedPitch=0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01',Duration=4.0)
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02',Duration=4.0)
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03',Duration=2.0)
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04',Duration=1.0)

    bIsArtillery=true
    ResupplyInterval=25.0
}
