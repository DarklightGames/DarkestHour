//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PPSH41_stickFire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=Class'DH_PPSH41_stickBullet'
    AmmoClass=Class'DH_PPS43Ammo'
    FireRate=0.075 // 913 rpm (value had to be found experimentally due to an engine bug)
    Spread=135.0

    // Recoil
    RecoilRate=0.03335
    MaxVerticalRecoilAngle=245
    MaxHorizontalRecoilAngle=75
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.33),(InVal=2.0,OutVal=0.7),(InVal=4.0,OutVal=0.8),(InVal=10.0,OutVal=1.1),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=18.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.ppsh41_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.ppsh41_fire_end'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.ppsh41_fire_single1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.ppsh41_fire_single2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.ppsh41_fire_single3'

    FlashEmitterClass=Class'MuzzleFlash1stPPSH'
    ShellEjectClass=Class'ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=11000)

    FireIronEndAnim="iron_shoot_end"
    FireIronLastAnim="iron_shoot_end_empty"
    FireLastAnim="shoot_end_empty"
    FireEndAnim="shoot_end"
}
