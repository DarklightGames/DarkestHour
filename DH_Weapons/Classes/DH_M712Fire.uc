//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M712Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=Class'DH_M712Bullet'
    AmmoClass=Class'DH_M712Ammo'
    FireRate=0.075 // 913 rpm (value had to be found experimentally due to an engine bug)
    Spread=180.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=275
    MaxHorizontalRecoilAngle=120
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.3),(InVal=2.0,OutVal=0.7),(InVal=6.0,OutVal=1.3),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=10.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.C96_FireLoop01'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.C96_FireSingle01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.C96_FireSingle02'
    FireEndSound=SoundGroup'DH_WeaponSounds.C96_FireEnd01'
    FlashEmitterClass=Class'MuzzleFlash1stPistol'

    ShellEjectClass=Class'ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)

    FireIronLastAnim="iron_shoot_last"
    FireLastAnim="shoot_last"
}
