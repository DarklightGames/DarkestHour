//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_45mmM1937GunCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_45mm_anm.45mmM1937_gun'
    Skins(0)=Texture'DH_Artillery_tex.45mmATGun.45mmATgun'
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.45mmGun.45mmGun_gun_collision'

    // Turret movement
    RotationsPerSecond=0.05
    MaxPositiveYaw=5461 // 30 degrees
    MaxNegativeYaw=-5461
    YawStartConstraint=-6000.0
    YawEndConstraint=6000.0
    CustomPitchUpLimit=2366 // +13/-5 (should be +25 degrees, but any higher & barrel clips through gun shield)
    CustomPitchDownLimit=64200

    // Cannon ammo
    ProjectileClass=class'DH_Guns.DH_45mmM1937GunCannonShell'
    PrimaryProjectileClass=class'DH_Guns.DH_45mmM1937GunCannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_45mmM1937GunCannonShellHE'
    ProjectileDescriptions(0)="APBC"
    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=10
    MaxPrimaryAmmo=60
    MaxSecondaryAmmo=30
    SecondarySpread=0.002

    // Weapon fire
    WeaponFireOffset=-11.4
    EffectEmitterClass=class'ROEffects.TankCannonFireEffectTypeC' // smaller muzzle flash effect

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.Panzer_III_reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.Panzer_III_reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.Panzer_III_reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.Panzer_III_reload_04')

    // Cannon range settings
    RangeSettings(0)=0
    RangeSettings(1)=500
    RangeSettings(2)=1000
    RangeSettings(3)=1500
    RangeSettings(4)=2000
    RangeSettings(5)=2500
}
