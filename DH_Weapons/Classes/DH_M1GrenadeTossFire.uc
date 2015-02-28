//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M1GrenadeTossFire extends DH_GrenadeFire;

defaultproperties
{
    AmmoClass=class'DH_Weapons.DH_M1GrenadeAmmo'
    ProjectileClass=class'DH_Weapons.DH_M1GrenadeProjectile'

    AddedFuseTime=0.0           // undoing DH_GrenadeFire
    bPullAnimCompensation=false // undoing DH_GrenadeFire
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0
    AddedPitch=0
    PreFireAnim="Pre_Fire"
    FireAnim="Toss"
}
