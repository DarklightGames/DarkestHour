//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_KorovinFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_KorovinBullet'
    AmmoClass=Class'DH_PPS43Ammo'
    FireRate=0.14 // ~474 rpm (value had to be found experimentally due to an engine bug)
    Spread=140.0

    // Recoil
    RecoilRate=0.075
    MaxVerticalRecoilAngle=280
    MaxHorizontalRecoilAngle=80
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.7),(InVal=5.0,OutVal=0.85),(InVal=12.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=10.0

    FireSounds(0)=SoundGroup'DH_old_inf_Weapons.korovinfire1'
    FireSounds(1)=SoundGroup'DH_old_inf_Weapons.korovinfire2'
    FireSounds(2)=SoundGroup'DH_old_inf_Weapons.korovinfire3'

    FlashEmitterClass=Class'MuzzleFlash1stPPSH'
    ShellEjectClass=Class'ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=5000)

    FireIronLastAnim="iron_idle_empty"
    FireLastAnim="shoot_end_empty"
}
