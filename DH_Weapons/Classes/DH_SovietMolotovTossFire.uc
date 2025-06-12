//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SovietMolotovTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_SovietMolotovProjectile'
    AmmoClass=class'DH_Weapons.DH_SovietMolotovAmmo'

    AddedPitch=0
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0

    FireAnim="Toss"
}
