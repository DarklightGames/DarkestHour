//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_IncendiaryBottleNo1TossFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_IncendiaryBottleNo1Projectile'
    AmmoClass=class'DH_Weapons.DH_IncendiaryBottleNo1Ammo'

    AddedPitch=0
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0

    FireAnim="Toss"
}
