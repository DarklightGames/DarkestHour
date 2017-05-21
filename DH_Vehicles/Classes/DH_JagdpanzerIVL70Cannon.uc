//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_JagdpanzerIVL70Cannon extends DH_JagdpanzerIVL48Cannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L70_turret_ext'

    // Cannon movement
    ManualRotationsPerSecond=0.025

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL70CannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL70CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL70CannonShellAPCR'
    TertiaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL70CannonShellHE'
    ProjectileDescriptions(1)="APCR"
    ProjectileDescriptions(2)="HE"
    InitialPrimaryAmmo=35
    InitialSecondaryAmmo=5
    InitialTertiaryAmmo=15
    SecondarySpread=0.00165
    TertiarySpread=0.0012

    // Weapon fire
    WeaponFireAttachmentBone="Barrel"
    WeaponFireOffset=6.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panther.75mm_VL_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panther.75mm_VL_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panther.75mm_VL_fire03'
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.STUG_III_reload_01')
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.STUG_III_reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.STUG_III_reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.STUG_III_reload_04')
}
