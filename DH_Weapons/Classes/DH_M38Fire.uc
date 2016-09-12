//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M38Fire extends DHBoltFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-30.0)
    FireIronAnim="Iron_shootrest"
    FireSounds(0)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire03'
    MaxVerticalRecoilAngle=1550
    MaxHorizontalRecoilAngle=200
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    ShellIronSightOffset=(X=10.0,Y=3.0,Z=-5.0)
    ShellRotOffsetHip=(Pitch=5000)
    bWaitForRelease=true
    FireAnim="shoot_last"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=2.4
    AmmoClass=class'ROAmmo.MN762x54RAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=350.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=2.5
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_M38Bullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=800.0
    Spread=60.0
    SpreadStyle=SS_Random
}
