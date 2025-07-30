//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PPS43Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_PPS43Bullet'
    AmmoClass=Class'PPS43Ammo'
    FireRate=0.095 // ~702 rpm (value had to be found experimentally due to an engine bug)
    Spread=135.0

    // Recoil
    RecoilRate=0.04285
    MaxVerticalRecoilAngle=270
    MaxHorizontalRecoilAngle=80
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.7),(InVal=6.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=13.0

    FireSounds(0)=SoundGroup'DH_WeaponSounds.PPS43_Single1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.PPS43_Single2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.PPS43_Single3'
    FlashEmitterClass=Class'MuzzleFlash1stPPSH'
    ShellEjectClass=Class'ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=5000)

    FireIronLastAnim="iron_idle_empty"
}
