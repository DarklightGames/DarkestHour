//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_STG44Fire extends DHAutomaticFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-28.0)
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire03'
    MaxVerticalRecoilAngle=650
    MaxHorizontalRecoilAngle=120
    PctStandIronRecoil=0.7
    PctCrouchIronRecoil=0.45
    PctProneIronRecoil=0.3
    RecoilRate=0.07
    ShellEjectClass=class'ROAmmo.ShellEject1st556mm'
    ShellIronSightOffset=(X=15.0,Z=-2.5)
    ShellRotOffsetIron=(Pitch=2000)
    bReverseShellSpawnDirection=true
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    TweenTime=0.0
    FireRate=0.14
    AmmoClass=class'ROAmmo.STG44Ammo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=175.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.75
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_STG44Bullet'
    BotRefireRate=0.99
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSTG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=1200.0
    Spread=145.0
    SpreadStyle=SS_Random
}
