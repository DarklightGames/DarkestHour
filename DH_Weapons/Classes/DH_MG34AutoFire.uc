//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MG34AutoFire extends DHMGAutomaticFire;

defaultproperties
{
    PctHipMGPenalty=0.66
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    AmbientFireSoundRadius=750.0
    AmbientFireSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientFireVolume=255
    PackingThresholdTime=0.12
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-20.0)
    bUsesTracers=true
    TracerFrequency=7
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    FireIronAnim="Shoot_Loop"
    FireIronLoopAnim="Bipod_Shoot_Loop"
    FireIronEndAnim="Bipod_Shoot_End"
    MaxVerticalRecoilAngle=600
    MaxHorizontalRecoilAngle=250
    RecoilRate=0.04
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Z=-10.0)
    ShellRotOffsetIron=(Pitch=-13000)
    ShellRotOffsetHip=(Pitch=-13000)
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Hip_Shoot_End"
    TweenTime=0.0
    FireRate=0.070588
    AmmoClass=class'ROAmmo.MG50Rd792x57DrumAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2.0
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    BotRefireRate=0.99
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=1800.0
    Spread=65.0
    BipodDeployedSpreadModifier=1.0
    ProneSpreadModifier=1.0
    CrouchSpreadModifier=1.0
    RestDeploySpreadModifier=1.0
    SpreadStyle=SS_Random
}
