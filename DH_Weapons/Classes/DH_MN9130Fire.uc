//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130Fire extends DHBoltFire;

defaultproperties
{
    AmmoClass=class'ROAmmo.MN762x54RAmmo'
    AmmoPerFire=1
    ProjectileClass=class'DH_Weapons.DH_MN9130Bullet'
    ProjSpawnOffset=(X=25.0,Y=0.0,Z=0.0)
    FAProjSpawnOffset=(X=-35.0,Y=0.0,Z=0.0)
    SpreadStyle=SS_Random
    Spread=40.0
    ShellIronSightOffset=(X=10.0,Y=3.0,Z=-5.0)
    ShellHipOffset=(X=0.0,Y=0.0,Z=0.0)
    MaxVerticalRecoilAngle=1500
    MaxHorizontalRecoilAngle=100
    bWaitForRelease=true
    FireAnimRate=1.0
    FireRate=2.4
    TweenTime=0.0
    FireAnim="shoot_last"
    FireIronAnim="iron_shootrest"
    FireSounds(0)=sound'Inf_Weapons.nagant9130.nagant9130_fire01'
    FireSounds(1)=sound'Inf_Weapons.nagant9130.nagant9130_fire02'
    FireSounds(2)=sound'Inf_Weapons.nagant9130.nagant9130_fire03'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stNagant'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    bSplashDamage=false
    bRecommendSplashDamage=false
    bSplashJump=false
    BotRefireRate=0.5
    WarnTargetPct=0.9
    AimError=800
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=300.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=2.0
    FireForce="RocketLauncherFire"
}
