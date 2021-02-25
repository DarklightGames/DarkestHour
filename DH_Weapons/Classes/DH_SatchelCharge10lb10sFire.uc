//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
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

        if (Weapon != none)
        {
            Weapon.PutDown();
            Weapon.PostFire();
        }
    }
}

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_SatchelCharge10lb10sProjectile'
    AmmoClass=class'DH_Weapons.DH_SachelChargeAmmo'
    ProjSpawnOffset=(X=-5.0)
    AddedPitch=150
    MinimumThrowSpeed=200.0
    MaximumThrowSpeed=400.0
    MaxHoldTime=6
    SpeedFromHoldingPerSec=450.0
    PreFireAnim="Plant"
}
