//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// TODO:
// [ ] The shells eject the wrong direction
//==============================================================================

class DH_MAB38Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_MAB38Bullet'
    AmmoClass=Class'DH_MAB38Ammo'
    FAProjSpawnOffset=(X=-28.0)
    FireRate=0.115 // ~575 rpm (value had to be found experimentally due to an engine bug)

    Spread=120.0

    // Recoil
    RecoilRate=0.04285
    MaxVerticalRecoilAngle=230
    MaxHorizontalRecoilAngle=66
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=8.0,OutVal=1.1),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=13.0

    FlashEmitterClass=Class'MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Mabsingle01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Mabsingle02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Mabsingle03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.dryfire_smg'
    ShellEjectClass=Class'ShellEject1st9x19mm'

    ShellRotOffsetIron=(Pitch=25000)
    ShellRotOffsetHip=(Pitch=10000,Yaw=-16384)

    FireIronLastAnim="iron_shoot_end_empty"
    FireLastAnim="shoot_end_empty"
}
