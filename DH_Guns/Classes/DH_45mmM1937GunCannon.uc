//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_45mmM1937GunCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_45mm_anm.45mmM1937_gun'
    Skins(0)=Texture'DH_Artillery_tex.45mmATgun'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.45mmGun_gun_collision')

    // Turret movement
    RotationsPerSecond=0.05
    MaxPositiveYaw=5461 // 30 degrees
    MaxNegativeYaw=-5461
    YawStartConstraint=-6000.0
    YawEndConstraint=6000.0
    CustomPitchUpLimit=2766 // +16/-5 (should be +25 degrees, but any higher & barrel clips through gun shield)
    CustomPitchDownLimit=64200

    // Cannon ammo
    PrimaryProjectileClass=Class'DH_45mmM1937GunCannonShell'
    SecondaryProjectileClass=Class'DH_45mmM1937GunCannonShellHE'
    //TertiaryProjectileClass=Class'DH_45mmM1937GunCannonShellAPCR'

    ProjectileDescriptions(0)="APBC"

    nProjectileDescriptions(0)="BR-240"
    nProjectileDescriptions(1)="O-240"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=15

    MaxPrimaryAmmo=40
    MaxSecondaryAmmo=20
    //MaxTertiaryAmmo=6
    SecondarySpread=0.002

    // Weapon fire
    WeaponFireOffset=-11.4
    EffectEmitterClass=Class'TankCannonFireEffectTypeC' // smaller muzzle flash effect

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_CC_Vehicle_Weapons.45mmAT_fire01'
    CannonFireSound(1)=SoundGroup'DH_CC_Vehicle_Weapons.45mmAT_fire02'
    CannonFireSound(2)=SoundGroup'DH_CC_Vehicle_Weapons.45mmAT_fire03'
    ReloadStages(0)=(Sound=none) //~2.8 seconds reload for a lower caliber AT gun
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.reload_short_4')

    // Cannon range settings
    RangeSettings(0)=0
    RangeSettings(1)=500
    RangeSettings(2)=1000
    RangeSettings(3)=1500
    RangeSettings(4)=2000
    RangeSettings(5)=2500
}
