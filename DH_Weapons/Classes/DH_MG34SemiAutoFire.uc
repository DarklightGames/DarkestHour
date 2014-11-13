//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MG34SemiAutoFire extends DH_MGSingleFire;

defaultproperties
{
     PctHipMGPenalty=1.500000
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-20.000000)
     bUsesTracers=true
     TracerFrequency=6
     DummyTracerClass=Class'DH_Weapons.DH_MG34ClientTracer'
     FireIronAnim="Shoot_Loop"
     FireIronLoopAnim="Bipod_shoot_single"
     FireIronEndAnim="Bipod_Shoot_End"
     FireSounds(0)=SoundGroup'Inf_Weapons.mg34.mg34_fire_single'
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=250
     RecoilRate=0.040000
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
     ShellIronSightOffset=(X=25.000000,Z=-10.000000)
     ShellRotOffsetIron=(Pitch=0)
     FireAnim="Bipod_shoot_single"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=0.200000
     AmmoClass=Class'ROAmmo.MG50Rd792x57DrumAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'DH_Weapons.DH_MG34Bullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stMG'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1800.000000
     Spread=125.000000
     SpreadStyle=SS_Random
}
