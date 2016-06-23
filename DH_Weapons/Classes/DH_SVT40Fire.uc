//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40Fire extends DHSemiAutoFire;

defaultproperties
{
    AmmoClass=class'SVT40Ammo'
    AmmoPerFire=1

    ProjectileClass = class'DH_Weapons.DH_SVT40Bullet'
    ProjSpawnOffset=(X=25,Y=0,Z=0)
    FAProjSpawnOffset=(X=-35,Y=0,Z=0)
    SpreadStyle=SS_Random
    Spread = 150

    ShellIronSightOffset=(X=15,Y=0,Z=0)
    ShellHipOffset=(X=0,Y=0,Z=0)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=0,Roll=-3000)

    maxVerticalRecoilAngle=2000
    maxHorizontalRecoilAngle=250

    bWaitForRelease = true

    FireAnimRate=1.0
    FireRate=0.2
    TweenTime=0.0
    FireAnim=Shoot
    FireIronAnim=Iron_Shoot

    FireSounds(0) = Sound'Inf_Weapons.svt40.svt40_fire01'
    FireSounds(1) = Sound'Inf_Weapons.svt40.svt40_fire02'
    FireSounds(2) = Sound'Inf_Weapons.svt40.svt40_fire03'

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSVT'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    ShellEmitBone=ejector

    bSplashDamage=false
    bRecommendSplashDamage=false
    bSplashJump=false
    BotRefireRate=0.5
    WarnTargetPct=+0.9
    AimError=1500

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=200.0)
    ShakeRotRate=(X=12500.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0

    FireForce="RocketLauncherFire"
}

