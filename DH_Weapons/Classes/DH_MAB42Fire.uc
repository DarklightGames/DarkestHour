//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MAB42Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MAB42Bullet'
    AmmoClass=class'DH_MAB42Ammo'
    FAProjSpawnOffset=(X=-28.0)
    FireRate=0.1 //600 per minute

    Spread=180.0    // shorter barrel than the MAB38

    // Recoil
    RecoilRate=0.04285
    MaxVerticalRecoilAngle=230
    MaxHorizontalRecoilAngle=66
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=8.0,OutVal=1.1),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=13.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.MAB38.Mabsingle01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.MAB38.Mabsingle02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.MAB38.Mabsingle03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'

    ShellRotOffsetIron=(Pitch=25000)
    ShellRotOffsetHip=(Pitch=0)

    FireIronLastAnim="iron_shoot_end_empty"
    FireLastAnim="shoot_end_empty"
}
