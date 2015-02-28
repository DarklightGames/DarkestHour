//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_SatchelCharge10lb10sFire extends SatchelCharge10lb10sFire;

// Overridden to require satchel to be held for 1 second
event ModeDoFire()
{
    if (HoldTime < 1.0)
    {
        HoldTime = 0;
        Weapon.PutDown();
        ROExplosiveWeapon(Weapon).PostFire();
        return;
    }

    super.ModeDoFire();
}

defaultproperties
{
    minimumThrowSpeed=200.0 //was 300.0
    maximumThrowSpeed=350.0 //was 450.0
    speedFromHoldingPerSec=450.0 //was 850.0
    AddedPitch=250 //was 1000
    MaxHoldTime=2.5 //can only cook off for 2-3 seconds

    AmmoClass=class'DH_Weapons.DH_SachelChargeAmmo'
    ProjectileClass=class'DH_Weapons.DH_SatchelCharge10lb10sProjectile'
}
