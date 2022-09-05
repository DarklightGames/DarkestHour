//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MP41RFire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MP41RBullet'
    AmmoClass=class'DH_Weapons.DH_MP40Ammo'
    FireRate=0.08 // ~861 rpm (value had to be found experimentally due to an engine bug), assuming it fires a little bit slower than PPSh in 7.62 + gives me an excuse to use slightly different slowed down fire sound
    Spread=135.0

    // Recoil
    RecoilRate=0.03335
    MaxVerticalRecoilAngle=235
    MaxHorizontalRecoilAngle=71
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.33),(InVal=2.0,OutVal=0.7),(InVal=4.0,OutVal=0.8),(InVal=10.0,OutVal=1.1),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=18.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.ppsh41.mp41r_fire_loopg'
    FireEndSound=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_end'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single3'

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=11000)

    FireIronEndAnim="iron_shoot_end"
    FireIronLastAnim="iron_shoot_end_empty"
    FireLastAnim="shoot_end_empty"
    FireEndAnim="shoot_end"
}
