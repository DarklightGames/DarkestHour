//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ColtM1911Fire extends DHPistolFire;

defaultproperties
{
    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-15.0)
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Colt45.Colt45_Fire01'
    MaxVerticalRecoilAngle=600
    MaxHorizontalRecoilAngle=75
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellIronSightOffset=(X=10.0)
    ShellHipOffset=(Y=3.0)
    ShellRotOffsetHip=(Pitch=2500,Yaw=4000)
    bReverseShellSpawnDirection=true
    bWaitForRelease=true
    FireAnim="shoot"
    TweenTime=0.0
    FireRate=0.25
    AmmoClass=class'DH_Weapons.DH_ColtM1911Ammo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=1.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_ColtM1911Bullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    AimError=800.0
    Spread=430.0
    SpreadStyle=SS_Random
}
