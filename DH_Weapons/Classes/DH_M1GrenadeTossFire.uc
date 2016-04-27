//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M1GrenadeTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    AmmoClass=class'DH_Weapons.DH_M1GrenadeAmmo'
    ProjectileClass=class'DH_Weapons.DH_M1GrenadeProjectile'

    AddedFuseTime=0.0           // undoing DHThrownExplosiveFire
    bPullAnimCompensation=false // undoing DHThrownExplosiveFire
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0
    AddedPitch=0
    PreFireAnim="Pre_Fire"
    FireAnim="Toss"
}
