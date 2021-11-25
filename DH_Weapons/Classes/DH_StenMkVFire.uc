//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_StenMkVFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_StenMkVBullet'
    AmmoClass=class'DH_Weapons.DH_StenMkIIAmmo'
    FireRate=0.1016 // 590rpm
    Spread=135.0

    // Recoil
    RecoilRate=0.075
    MaxVerticalRecoilAngle=250
    MaxHorizontalRecoilAngle=80
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.7),(InVal=5.0,OutVal=0.85),(InVal=12.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0))))
    RecoilFallOffFactor=9.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Sten.Sten_fire_g1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Sten.Sten_fire_g2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Sten.Sten_fire_g3'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    //PreFireAnim="Shoot1_start"

    //Ejected shell params
    ShellCaseEjectClass=class'DH_Effects.DHShellEject1st9x19mm'
    ShellEjectOffset=(X=-1.0,Y=-3.0,Z=0.5)
    ShellVelMinX=150.0
    ShellVelMaxX=250.0
    ShellVelMinY=-25 //200
    ShellVelMaxY=25.0 //300.0
    ShellVelMinZ=50.0
    ShellVelMaxZ=100.0

    FireIronLastAnim="iron_shoot_last"
    FireLastAnim="shoot_last"
}
