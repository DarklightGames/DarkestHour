//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MG42Fire extends DHMGAutomaticFire;

defaultproperties
{
    FireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
    AmbientFireSoundRadius=750.0
    AmbientFireSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    AmbientFireVolume=255
    PackingThresholdTime=0.12
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-145.0,Y=-15.0,Z=-15.0)
    bUsesTracers=true
    TracerFrequency=7
    TracerProjectileClass=class'DH_Weapons.DH_MG42TracerBullet'
    FireIronAnim="Shoot_Loop"
    FireIronLoopAnim="Shoot_Loop"
    FireIronEndAnim="Shoot_End"
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=250
    RecoilRate=0.03125
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=15.0,Z=-6.0)
    ShellRotOffsetIron=(Pitch=-1500)
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    TweenTime=0.0
    FireRate=0.05
    AmmoClass=class'DH_Weapons.DH_MG42Ammo'
    ShakeRotMag=(X=40.0,Y=40.0,Z=40.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeRotTime=0.75
    ShakeOffsetMag=(X=4.0,Y=2.0,Z=4.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_MG42Bullet'
    BotRefireRate=0.99
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=1800.0
    Spread=66.0
    BipodDeployedSpreadModifier=1.0
    ProneSpreadModifier=1.0
    CrouchSpreadModifier=1.0
    RestDeploySpreadModifier=1.0
    SpreadStyle=SS_Random
}
