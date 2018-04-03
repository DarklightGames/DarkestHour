//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHRocketWeaponPickup extends DHWeaponPickup
    abstract;

// Override to circumvent check for CurrentMagIndex
function InitDroppedPickupFor(Inventory Inv)
{
    local DHProjectileWeapon W;
    local int i;

    W = DHProjectileWeapon(Inv);

    if (W != none)
    {
        AmmoAmount[0] = W.AmmoAmount(0);
        AmmoAmount[1] = W.AmmoAmount(1);
        bHasBayonetMounted = W.bBayonetMounted;
    }

    SetPhysics(PHYS_Falling);
    GotoState('FallingPickup');
    Inventory = Inv;
    bAlwaysRelevant = false;
    bOnlyReplicateHidden = false;
    bUpdateSimulatedPosition = true;
    bDropped = true;
    bIgnoreEncroachers = false;
    NetUpdateFrequency = 8;

    if (W != none)
    {
        // Store the ammo mags from the weapon
        for (i = 0; i < W.PrimaryAmmoArray.Length; ++i)
        {
            AmmoMags[AmmoMags.Length] = W.PrimaryAmmoArray[i];
        }

        // Ensure that AmmoMags has at least 1 item (otherwise it bugs other things)
        AmmoMags.Length = Max(AmmoMags.Length, 1);

        // If weapon has barrels, transfer over any barrels
        if (W.Barrels.Length > 0)
        {
            Barrels = W.Barrels; // copy the weapon's reference to the Barrels array

            for (i = 0; i < Barrels.Length; ++i)
            {
                if (Barrels[i] != none)
                {
                    Barrels[i].SetOwner(self); // barrel's owner is now this pickup

                    if (Barrels[i].bIsCurrentBarrel)
                    {
                        BarrelIndex = i;
                        Barrels[BarrelIndex].UpdateBarrelStatus();
                    }
                }
            }
        }
    }
}

defaultproperties
{
}
