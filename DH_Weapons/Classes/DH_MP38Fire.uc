//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MP38Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_MP38Bullet'
    AmmoClass=Class'DH_MP40Ammo'
    FireRate=0.135 // ~490rpm (value had to be found experimentally due to an engine bug)
    Spread=122.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=220
    MaxHorizontalRecoilAngle=66
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.45),(InVal=5.0,OutVal=0.6),(InVal=12.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=14.0

    FlashEmitterClass=Class'MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.mp40_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.mp40_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.mp40_fire03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.dryfire_smg'
    ShellEjectClass=Class'ShellEject1st9x19mm'

    FireIronLastAnim="iron_idle_empty"
    FireLastAnim="shoot_last"
}
