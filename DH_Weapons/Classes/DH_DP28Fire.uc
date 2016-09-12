//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_DP28Fire extends DHMGAutomaticFire;

defaultproperties
{
    FireEndSound=SoundGroup'Inf_Weapons.dp1927.dp1927_fire_end'
    AmbientFireSoundRadius=750.0
    AmbientFireSound=SoundGroup'Inf_Weapons.dp1927.dp1927_fire_loop'
    AmbientFireVolume=255
    //compile error  ServerProjectileClass=class'DH_Weapons.DH_DP28Bullet_S'
    PackingThresholdTime=0.12
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-20.0)
    bUsesTracers=true
    TracerFrequency=5
    //compile error  DummyTracerClass=class'DH_Weapons.DH_DP28ClientTracer'
    FireIronAnim="Bipod_Shoot_Loop"
    FireIronLoopAnim="Bipod_Shoot_Loop"
    FireIronEndAnim="Bipod_Shoot_End"
    MaxVerticalRecoilAngle=450
    MaxHorizontalRecoilAngle=200
    RecoilRate=0.05
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    ShellIronSightOffset=(X=15.0,Z=-5.0)
    ShellHipOffset=(X=-20.0)
    ShellRotOffsetIron=(Pitch=0)
    ShellRotOffsetHip=(Yaw=10000)
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    TweenTime=0.0
    FireRate=0.1
    AmmoClass=class'ROAmmo.DP28Ammo'
    ShakeRotMag=(X=75.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    BotRefireRate=0.99
    WarnTargetPct=0.90
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stDP'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=1800.0
    Spread=175.0
    SpreadStyle=SS_Random
}
