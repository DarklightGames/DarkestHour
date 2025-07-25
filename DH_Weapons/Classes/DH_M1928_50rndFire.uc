//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1928_50rndFire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=Class'DH_ThompsonBullet'
    AmmoClass=Class'DH_M1928_50rndAmmo'
    FireRate=0.085 // ~800rpm (value had to be found experimentally due to an engine bug)
    Spread=140.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=245
    MaxHorizontalRecoilAngle=115
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.33),(InVal=2.0,OutVal=0.6),(InVal=5.0,OutVal=0.7),(InVal=9.0,OutVal=1.2),(InVal=20.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=12.0

    FlashEmitterClass=Class'MuzzleFlash1stPistol'
    AmbientFireSound=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson_fireloop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson_fireend1'
    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson_fire01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson_fire02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson_fire03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.dryfire_smg'
    //PreFireAnim="Shoot1_start"
    ShellEjectClass=Class'ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)

    FireIronEndAnim="iron_shoot_end"
    FireIronLastAnim="iron_idle_empty"
    FireLastAnim="shoot_end_empty"
    FireEndAnim="shoot_end"
}
