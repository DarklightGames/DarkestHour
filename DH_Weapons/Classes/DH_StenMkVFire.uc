//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_StenMkVFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_StenMkVBullet'
    AmmoClass=Class'DH_StenMkIIAmmo'
    FireRate=0.115 // ~575rpm  (value had to be found experimentally due to an engine bug)
    Spread=135.0

    // Recoil
    RecoilRate=0.075
    MaxVerticalRecoilAngle=250
    MaxHorizontalRecoilAngle=80
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.7),(InVal=5.0,OutVal=0.85),(InVal=12.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=9.0

    FlashEmitterClass=Class'MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Sten_fire_g1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Sten_fire_g2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Sten_fire_g3'
    NoAmmoSound=Sound'Inf_Weapons_Foley.dryfire_smg'
    //PreFireAnim="Shoot1_start"
    ShellEjectClass=Class'ShellEject1st9x19mm'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=-2.5)
    ShellRotOffsetIron=(Pitch=2000)

    FireIronLastAnim="iron_shoot_last"
    FireLastAnim="shoot_last"
}
