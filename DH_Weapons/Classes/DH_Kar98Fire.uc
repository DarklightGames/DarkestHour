//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Kar98Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_Kar98Bullet'
    AmmoClass=class'DH_Weapons.DH_Kar98Ammo'
    FireRate=2.6
    FAProjSpawnOffset=(X=-30.0)
    Spread=30.0
    FireSounds(0)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire03'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetIron=(Pitch=14000)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=7500.0)
}
