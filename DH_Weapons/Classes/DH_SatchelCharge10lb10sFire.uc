//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SatchelCharge10lb10sFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_SatchelCharge10lb10sProjectile'
    AmmoClass=class'DH_Weapons.DH_SachelChargeAmmo'
    ProjSpawnOffset=(X=-5.0)
    AddedPitch=150
    MinimumThrowSpeed=200.0
    MaximumThrowSpeed=400.0
    MaxHoldTime=6.0
    MinHoldTime=1.0
    SpeedFromHoldingPerSec=450.0
    PreFireAnim="Plant"
}
