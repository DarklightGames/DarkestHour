//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_P38Fire extends DH_PistolFire;

defaultproperties
{
    FireLastAnim="Shoot_Empty"
    FireIronLastAnim="iron_shoot_empty"
    ProjSpawnOffset=(X=25.000000)
    FAProjSpawnOffset=(X=-15.000000)
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire03'
    maxVerticalRecoilAngle=600
    maxHorizontalRecoilAngle=75
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellIronSightOffset=(X=10.000000)
    bWaitForRelease=true
    FireAnim="shoot"
    TweenTime=0.000000
    FireRate=0.200000
    AmmoClass=class'ROAmmo.P38Ammo'
    ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
    ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
    ShakeRotTime=1.000000
    ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=1.000000
    ProjectileClass=class'DH_Weapons.DH_P38Bullet'
    BotRefireRate=0.500000
    WarnTargetPct=0.900000
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    aimerror=800.000000
    Spread=430.000000
    SpreadStyle=SS_Random
}
