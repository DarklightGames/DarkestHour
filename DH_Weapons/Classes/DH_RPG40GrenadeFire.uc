//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_RPG40GrenadeFire extends DHThrownExplosiveFire;

// Modified to require satchel to be held for half a second
event ModeDoFire()
{
    if (HoldTime >= 0.5)
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
    ProjectileClass=class'DH_Weapons.DH_RPG40GrenadeProjectile'
    AmmoClass=class'DH_Weapons.DH_RPG40GrenadeAmmo'

    MaxHoldTime=160.0 // why hold a grenade for more than a minute?
    bSplashDamage=false
    bRecommendSplashDamage=false
    AddedFuseTime=9.0  // should be enough for the grenade to fly and land somewhere, so if it doesnt explode for some reason it will few seconds after
    MinimumThrowSpeed=650.0
    MaximumThrowSpeed=720.0
    SpeedFromHoldingPerSec=600.0
}
