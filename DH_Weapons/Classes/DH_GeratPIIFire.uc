//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_GeratPIIFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_GeratPIIBullet'
    AmmoClass=class'DH_Weapons.DH_GeratPAmmo'
    FireRate=0.14 //
    Spread=190.0

    // Recoil
    RecoilRate=0.075
    MaxVerticalRecoilAngle=360
    MaxHorizontalRecoilAngle=100
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.7),(InVal=5.0,OutVal=0.85),(InVal=12.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=9.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Sten.GeratPII_fire_g1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Sten.GeratPII_fire_g2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Sten.GeratPII_fire_g3'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    //PreFireAnim="Shoot1_start"
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=-2.5)
    ShellRotOffsetIron=(Pitch=2000)

    FireIronLastAnim="iron_shoot_last"
    FireLastAnim="shoot_last"
}
