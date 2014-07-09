//=============================================================================
// DH_M1GrenadeFire
//=============================================================================

class DH_M1GrenadeFire extends ROThrownExplosiveFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     bUsePreLaunchTrace=False
     bWaitForRelease=True
     PreFireAnim="Pre_Fire"
     FireAnim="Throw"
     TweenTime=0.010000
     FireForce="RocketLauncherFire"
     FireRate=50.000000
     AmmoClass=Class'DH_Weapons.DH_M1GrenadeAmmo'
     ProjectileClass=Class'DH_Weapons.DH_M1GrenadeProjectile'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     aimerror=200.000000
     Spread=75.000000
     SpreadStyle=SS_Random
}
