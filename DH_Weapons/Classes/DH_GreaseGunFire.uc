//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GreaseGunFire extends DHAutomaticFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-20.0)
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire03'
    maxVerticalRecoilAngle=585
    maxHorizontalRecoilAngle=75
    PctProneIronRecoil=0.5
    RecoilRate=0.075
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellIronSightOffset=(X=15.0)
    ShellRotOffsetIron=(Pitch=1000)
    FireAnim="Shoot_Loop"
    TweenTime=0.0
    NoAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    FireRate=0.15
    AmmoClass=class'DH_Weapons.DH_GreaseGunAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_GreaseGunBullet'
    BotRefireRate=0.99
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=1200.0
    Spread=345.0
    SpreadStyle=SS_Random
}
