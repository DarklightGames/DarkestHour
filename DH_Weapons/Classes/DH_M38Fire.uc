//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M38Fire extends DHBoltFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.000000)
    FAProjSpawnOffset=(X=-30.000000)
    FireIronAnim="Iron_shootrest"
    FireSounds(0)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire03'
    maxVerticalRecoilAngle=1550
    maxHorizontalRecoilAngle=200
    ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mmGreen'
    ShellIronSightOffset=(X=10.000000,Y=3.000000,Z=-5.000000)
    ShellRotOffsetHip=(Pitch=5000)
    bWaitForRelease=True
    FireAnim="shoot_last"
    TweenTime=0.000000
    FireForce="RocketLauncherFire"
    FireRate=2.400000
    AmmoClass=Class'ROAmmo.MN762x54RAmmo'
    ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
    ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
    ShakeRotTime=2.500000
    ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=5.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=1.000000
    ProjectileClass=Class'DH_Weapons.DH_M38Bullet'
    BotRefireRate=0.500000
    WarnTargetPct=0.900000
    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
    SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
    aimerror=800.000000
    Spread=60.000000
    SpreadStyle=SS_Random
}
