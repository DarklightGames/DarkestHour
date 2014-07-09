//=============================================================================
// DH_M1GrenadeTossFire
//=============================================================================

class DH_M1GrenadeTossFire extends ROThrownExplosiveFire;

defaultproperties
{
     minimumThrowSpeed=100.000000
     maximumThrowSpeed=500.000000
     speedFromHoldingPerSec=800.000000
     ProjSpawnOffset=(X=25.000000)
     AddedPitch=0
     bUsePreLaunchTrace=False
     bWaitForRelease=True
     PreFireAnim="Pre_Fire"
     FireAnim="Toss"
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
