//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
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
    AddedPitch=250
    MinimumThrowSpeed=400.0
    MaximumThrowSpeed=550.0
    MaxHoldTime=2.5
    SpeedFromHoldingPerSec=450.0
    PreFireAnim="Plant"
}
