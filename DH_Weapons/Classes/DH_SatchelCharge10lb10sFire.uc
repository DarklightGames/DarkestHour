//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SatchelCharge10lb10sFire extends DHThrownExplosiveFire;

// Modified to require satchel to be held for 1 second
event ModeDoFire()
{
    if (HoldTime >= 1.0)
    {
        super.ModeDoFire();
    }
    else
    {
        HoldTime = 0.0;
        Weapon.PutDown();
        Weapon.PostFire();
    }
}

defaultproperties
{
    MinimumThrowSpeed=200.0 // was 300.0
    MaximumThrowSpeed=350.0 // was 450.0
    SpeedFromHoldingPerSec=450.0 // was 850.0
    AddedPitch=250  // was 1000
    MaxHoldTime=2.5 // can only cook off for 2-3 seconds
    PreFireAnim="Plant"
    AmmoClass=class'DH_Weapons.DH_SachelChargeAmmo'
    ProjectileClass=class'DH_Weapons.DH_SatchelCharge10lb10sProjectile'
    ProjSpawnOffset=(X=-5.0,Y=15.0,Z=-10.0)
}
