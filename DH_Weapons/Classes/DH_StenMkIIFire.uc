//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_StenMkIIFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_StenMkIIBullet'
    AmmoClass=class'DH_Weapons.DH_StenMkIIAmmo'
    FireRate=0.12
    Spread=320.0
    RecoilRate=0.075
    PctProneIronRecoil=0.5
    MaxVerticalRecoilAngle=400
    MaxHorizontalRecoilAngle=70
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Sten.Sten_fire_g1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Sten.Sten_fire_g2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Sten.Sten_fire_g3'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    PreFireAnim="Shoot1_start"
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=-1.5)
    ShellRotOffsetIron=(Pitch=-500)
}
