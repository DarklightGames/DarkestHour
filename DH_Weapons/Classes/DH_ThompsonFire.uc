//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ThompsonFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_ThompsonBullet'
    AmmoClass=class'DH_Weapons.DH_ThompsonAmmo'
    FireRate=0.092307 // 650rpm
    Spread=325.0
    RecoilRate=0.05
    MaxVerticalRecoilAngle=320
    MaxHorizontalRecoilAngle=60
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Thompson.Thompson_FireG1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Thompson.Thompson_FireG2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Thompson.Thompson_FireG3'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    PreFireAnim="Shoot1_start"
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)
}
