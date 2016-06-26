//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadeFire extends DHThrownExplosiveFire;

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
    AmmoClass=Class'ROAmmo.F1GrenadeAmmo'
    ProjectileClass=Class'DH_Weapons.DH_F1GrenadeProjectile'
    BotRefireRate=0.500000
    WarnTargetPct=0.900000
    aimerror=200.000000
    Spread=75.000000
    SpreadStyle=SS_Random
}
