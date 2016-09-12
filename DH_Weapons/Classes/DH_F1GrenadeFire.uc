//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadeFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    bUsePreLaunchTrace=false
    bWaitForRelease=true
    PreFireAnim="Pre_Fire"
    FireAnim="Throw"
    TweenTime=0.01
    FireForce="RocketLauncherFire"
    FireRate=50.0
    AmmoClass=class'ROAmmo.F1GrenadeAmmo'
    ProjectileClass=class'DH_Weapons.DH_F1GrenadeProjectile'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    AimError=200.0
    Spread=75.0
    SpreadStyle=SS_Random
}
