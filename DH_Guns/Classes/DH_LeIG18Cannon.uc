//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LeIG18Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret'
    Skins(0)=Texture'DH_LeIG18_tex.IG18_1'
    Skins(1)=Texture'DH_LeIG18_tex.IG18_2'
    GunnerAttachmentBone="com_player"

    // Animations
    ShootIntermediateAnim="shoot_close"

    // Turret movement
    RotationsPerSecond=0.01
    MaxPositiveYaw=1092.0
    MaxNegativeYaw=-1092.0
    YawStartConstraint=-1092.0
    YawEndConstraint=1092.0
    CustomPitchUpLimit=6371
    CustomPitchDownLimit=65535

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"

    nProjectileDescriptions(0)="Igr.38 Sprgr"
    nProjectileDescriptions(1)="Igr.38 HL/A"

    PrimaryProjectileClass=Class'DH_LeIG18CannonShellHE'
    SecondaryProjectileClass=Class'DH_LeIG18CannonShellHEAT'
    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=5
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=5
    Spread=0.020
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=16.0
    AddedPitch=0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.50mm_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.SU_76_Reload_01',Duration=2.0)
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.SU_76_Reload_02',Duration=2.0)
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.SU_76_Reload_03',Duration=1.0)
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.SU_76_Reload_04',Duration=1.0)

    bIsArtillery=true
    ResupplyInterval=12.0
}
