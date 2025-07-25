//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ThompsonFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_ThompsonBullet'
    AmmoClass=Class'DH_ThompsonAmmo'
    FireRate=0.1 // ~662 rpm (value had to be found experimentally due to an engine bug)
    Spread=140.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=300
    MaxHorizontalRecoilAngle=90
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=3.0,OutVal=0.66),(InVal=6.0,OutVal=1.2),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=12.0

    FlashEmitterClass=Class'MuzzleFlash1stPistol'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Thompson_FireG1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Thompson_FireG2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Thompson_FireG3'
    NoAmmoSound=Sound'Inf_Weapons_Foley.dryfire_smg'
    PreFireAnim="Shoot1_start"
    ShellEjectClass=Class'ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)
    ShellIronSightOffset=(X=20)
}
