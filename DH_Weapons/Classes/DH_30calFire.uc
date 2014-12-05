//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_30calFire extends DH_MGAutomaticFire;

defaultproperties
{
    FireEndSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_end01'
    AmbientFireSoundRadius=750.000000
    AmbientFireSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_loop01'
    AmbientFireVolume=255
    PackingThresholdTime=0.120000
    ServerProjectileClass=class'DH_Weapons.DH_30calBullet_S'
    ProjSpawnOffset=(X=25.000000)
    FAProjSpawnOffset=(X=-145.000000,Y=-15.000000,Z=-15.000000)
    bUsesTracers=true
    TracerFrequency=5
    DummyTracerClass=class'DH_Weapons.DH_30CalClientTracer'
    FireIronAnim="Shoot_Loop"
    FireIronLoopAnim="Shoot_Loop"
    FireIronEndAnim="Shoot_End"
    maxVerticalRecoilAngle=500
    maxHorizontalRecoilAngle=250
    RecoilRate=0.040000
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=15.000000,Z=-6.000000)
    ShellRotOffsetIron=(Pitch=-1500)
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    TweenTime=0.000000
    FireRate=0.120000
    AmmoClass=class'DH_Weapons.DH_30CalAmmo'
    ShakeRotMag=(X=25.000000,Y=25.000000,Z=25.000000)
    ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
    ShakeRotTime=1.750000
    ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=2.000000
    ProjectileClass=class'DH_Weapons.DH_30calBullet'
    BotRefireRate=0.990000
    WarnTargetPct=0.900000
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMG'
    aimerror=1800.000000
    Spread=125.000000
    SpreadStyle=SS_Random
}
