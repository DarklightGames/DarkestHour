//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MP40Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MP40Bullet'
    AmmoClass=class'DH_Weapons.DH_MP40Ammo'
    FireRate=0.13 // ~512rpm (value had to be found experimentally due to an engine bug)
    Spread=125.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=225
    MaxHorizontalRecoilAngle=70
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=5.0,OutVal=0.6),(InVal=12.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=14.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'

    FireIronLastAnim="iron_idle_empty"
    FireLastAnim="shoot_last"
}
