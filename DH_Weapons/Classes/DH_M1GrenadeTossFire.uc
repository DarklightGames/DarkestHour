//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M1GrenadeTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M1GrenadeProjectile'
    AmmoClass=class'DH_Weapons.DH_M1GrenadeAmmo'
    AddedPitch=0
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0
    PreFireAnim="Pre_Fire"
    FireAnim="Toss"
}
