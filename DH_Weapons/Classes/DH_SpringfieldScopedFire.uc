//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SpringfieldScopedFire extends DHBoltFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-35.0)
    FireIronAnim="Scope_Shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Springfield.Springfield_Fire01'
    MaxVerticalRecoilAngle=1000
    MaxHorizontalRecoilAngle=100
    PctRestDeployRecoil=0.25
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=10.0,Y=3.0,Z=-5.0)
    bWaitForRelease=true
    FireAnim="shoot_last"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=2.4
    AmmoClass=class'DH_Weapons.DH_SpringfieldAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=5.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_SpringfieldScopedBullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stNagant'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=500.0
    Spread=30.0
    SpreadStyle=SS_Random
}
