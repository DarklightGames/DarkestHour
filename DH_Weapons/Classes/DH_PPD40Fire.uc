//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PPD40Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=Class'DH_PPD40Bullet'
    AmmoClass=Class'DH_PPSh41Ammo'
    FireRate=0.085 // 800rpm (value had to be found experimentally due to an engine bug)
    Spread=135.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=270
    MaxHorizontalRecoilAngle=80
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.33),(InVal=2.0,OutVal=0.6),(InVal=4.0,OutVal=0.85),(InVal=10.0,OutVal=1.1),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=14.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.ppd40_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.ppd40_fire_end'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.ppd40_fire_single1'

    FlashEmitterClass=Class'MuzzleFlash1stPPSH'
    ShellEjectClass=Class'ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=5000)

    FireIronLastAnim="iron_idle_empty"
    FireLastAnim="shoot_last"
}
