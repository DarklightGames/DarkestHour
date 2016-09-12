//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadeTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    minimumThrowSpeed=100.0
    maximumThrowSpeed=500.0
    speedFromHoldingPerSec=800.0
    ProjSpawnOffset=(X=25.0)
    AddedPitch=0
    bUsePreLaunchTrace=false
    bWaitForRelease=true
    PreFireAnim="Pre_Fire"
    FireAnim="Toss"
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
