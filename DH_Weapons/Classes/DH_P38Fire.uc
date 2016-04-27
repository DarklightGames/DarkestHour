//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_P38Fire extends DHPistolFire;

defaultproperties
{
    FireLastAnim="Shoot_Empty"
    FireIronLastAnim="iron_shoot_empty"
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-15.0)
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire03'
    maxVerticalRecoilAngle=600
    maxHorizontalRecoilAngle=75
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellIronSightOffset=(X=10.0)
    bWaitForRelease=true
    FireAnim="shoot"
    TweenTime=0.0
    FireRate=0.2
    AmmoClass=class'ROAmmo.P38Ammo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=1.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_P38Bullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    aimerror=800.0
    Spread=430.0
    SpreadStyle=SS_Random
}
