//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHRocketWeaponPickup extends DHWeaponPickup
    abstract;

// Modified to circumvent check for CurrentMagIndex
function InitDroppedPickupFor(Inventory Inv)
{
    local DHProjectileWeapon W;
    local int i;

    super(ROWeaponPickup).InitDroppedPickupFor(Inv);

    W = DHProjectileWeapon(Inv);

    if (W != none)
    {
        // Store the ammo mags from the weapon
        for (i = 0; i < W.PrimaryAmmoArray.Length; ++i)
        {
            AmmoMags[AmmoMags.Length] = W.PrimaryAmmoArray[i];
        }
    }
}
