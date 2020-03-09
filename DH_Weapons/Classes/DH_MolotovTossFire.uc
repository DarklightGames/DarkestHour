//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MolotovProjectile'
    AmmoClass=class'DH_Weapons.DH_MolotovAmmo'

    AddedPitch=0
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0

    FireAnim="Toss"
}
