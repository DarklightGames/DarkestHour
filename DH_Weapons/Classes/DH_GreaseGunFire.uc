//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_GreaseGunFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_GreaseGunBullet'
    AmmoClass=class'DH_Weapons.DH_GreaseGunAmmo'
    FireRate=0.15 // ~441rpm (value had to be found experimentally due to an engine bug)
    Spread=148.0

    // Recoil
    RecoilRate=0.075
    MaxVerticalRecoilAngle=300
    MaxHorizontalRecoilAngle=100
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=3.0,OutVal=0.8),(InVal=12.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=10.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=1000)
}
