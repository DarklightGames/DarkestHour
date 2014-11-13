//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StielGranateFire extends ROThrownExplosiveFire;

defaultproperties
{
     AddedFuseTime=0.380000
     bPullAnimCompensation=true
     ProjSpawnOffset=(X=25.000000)
     bUsePreLaunchTrace=false
     bWaitForRelease=true
     PreFireAnim="Pre_Fire"
     FireAnim="Throw"
     TweenTime=0.010000
     FireForce="RocketLauncherFire"
     FireRate=50.000000
     AmmoClass=class'ROAmmo.StielGranateAmmo'
     ProjectileClass=class'DH_Weapons.DH_StielGranateProjectile'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     aimerror=200.000000
     Spread=75.000000
     SpreadStyle=SS_Random
}
