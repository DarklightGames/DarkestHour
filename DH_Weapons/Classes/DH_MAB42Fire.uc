//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MAB42Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_MAB42Bullet'
    AmmoClass=Class'DH_MAB42Ammo'
    FAProjSpawnOffset=(X=-28.0)
    FireRate=0.125 // ~532 rpm (value had to be found experimentally due to an engine bug)
    

    Spread=140.0    // shorter barrel than the MAB38; late-war lower quality

    // Recoil
    RecoilRate=0.04285
    MaxVerticalRecoilAngle=250  //slightly worse than mab38
    MaxHorizontalRecoilAngle=70
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=7.0,OutVal=1.1),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=13.0

    FlashEmitterClass=Class'MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Mabsingle01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Mabsingle02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Mabsingle03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.dryfire_smg'
    ShellEjectClass=Class'ShellEject1st9x19mm'

    ShellRotOffsetIron=(Pitch=25000)
    ShellRotOffsetHip=(Pitch=0)

    FireIronLastAnim="iron_shoot_end_empty"
    FireLastAnim="shoot_end_empty"
}
