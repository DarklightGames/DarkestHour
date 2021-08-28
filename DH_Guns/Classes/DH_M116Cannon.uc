//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M116Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M116_anm.m116_turret'
    Skins(0)=Texture'DH_M116_tex.M116.m116_body'
    GunnerAttachmentBone="com_player"

    // Turret movement
    ManualRotationsPerSecond=0.011111
    MaxPositiveYaw=546.0
    MaxNegativeYaw=-546.0
    YawStartConstraint=-546.0
    YawEndConstraint=546.0
    CustomPitchUpLimit=8192 // 45 degrees
    CustomPitchDownLimit=65358 // -5 degrees
    RotationsPerSecond=0.005 // ~3 degrees per second

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"

    nProjectileDescriptions(0)="Igr.38 Sprgr"   // TOD: get names of this
    nProjectileDescriptions(1)="Igr.38 HL/A"

    ProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'   // TODO: replace with m116 versions
    PrimaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'
    SecondaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHEAT'
    InitialPrimaryAmmo=60  // TODO: REPLACE
    InitialSecondaryAmmo=25  // TODO: REPLACE
    MaxPrimaryAmmo=60
    MaxSecondaryAmmo=25
    SecondarySpread=0.00125  // TODO: REPLACE

    // Weapon fire
    WeaponFireOffset=16.0  // TODO: REPLACE
    AddedPitch=-15  // TODO: REPLACE

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'  // TODO: REPLACE
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'  // TODO: REPLACE
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'  // TODO: REPLACE
    ReloadStages(0)=(Sound=none)
    ReloadStages(1)=(Sound=none) //fast reload for an AT gun
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04')

    bIsArtillery=true
}
