//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHWeaponPickup extends ROWeaponPickup
    abstract;

var     float       DH_MGCelsiusTemp, DH_MGCelsiusTemp2;
var     float       BarrelCoolingRate;
var     bool        bBarrelFailed, bBarrelFailed2, bHasSpareBarrel;
var     int         RemainingBarrel;

function InitDroppedPickupFor(Inventory Inv)
{
    local DH_ProjectileWeapon W;

    W = DH_ProjectileWeapon(Inv);

    super.InitDroppedPickupFor(Inv);

    if (W != none && W.BarrelArray.Length > 0 && W.ActiveBarrel >= 0 && W.ActiveBarrel < W.BarrelArray.Length)
    {
        DH_MGCelsiusTemp = W.BarrelArray[W.ActiveBarrel].DH_MGCelsiusTemp;
        BarrelCoolingRate = W.BarrelArray[W.ActiveBarrel].BarrelCoolingRate;
        bBarrelFailed = W.BarrelArray[W.ActiveBarrel].bBarrelFailed;

        if (W.RemainingBarrels > 1)
        {
            if (W.ActiveBarrel == 0)
            {
                RemainingBarrel = 1;
            }
            else
            {
                RemainingBarrel = 0;
            }

            DH_MGCelsiusTemp2 = W.BarrelArray[RemainingBarrel].DH_MGCelsiusTemp;

            bHasSpareBarrel = true;
        }
    }
}

function Tick(float dt)
{
    // make sure it's run on the
    if (Role < ROLE_Authority)
    {
        return;
    }

    // continue to lower the barrel temp
    DH_MGCelsiusTemp -= dt * BarrelCoolingRate;

    if (bHasSpareBarrel)
    {
        DH_MGCelsiusTemp2 -= dt * BarrelCoolingRate;
    }
}
