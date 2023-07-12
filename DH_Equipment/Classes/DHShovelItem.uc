//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelItem extends DHWeapon
    abstract;

function bool FillAmmo() { return false; }
function bool ResupplyAmmo() { return false; }
exec simulated function ROManualReload() { return; }

simulated function Fire(float F)
{
    local DHPawn P;

    P = DHPawn(Instigator);

    if (P != none && !P.CanBuildWithShovel())
    {
        // "You must have another squadmate nearby to use your shovel to build!"
        P.ReceiveLocalizedMessage(class'DHShovelWarningMessage', 1);
        return;
    }

    if (Instigator != none && Instigator.bIsCrawling)
    {
        class'DHShovelWarningMessage'.static.ClientReceive(PlayerController(Instigator.Controller), 0);
    }
    else
    {
        super.Fire(F);
    }
}

simulated event DigDone()
{
    local DHShovelBuildFireMode FM;

    FM = DHShovelBuildFireMode(FireMode[0]);

    if (FM != none)
    {
        FM.DigDone();
    }
}

// Modified to allow same InventoryGroup item (this shares same slot as wirecutters/satchel, each item on the slot requires multi-item support)
function bool HandlePickupQuery(Pickup Item)
{
    local int i;

    // If no passed item, prevent pick up & stops checking rest of Inventory chain
    if (Item == none)
    {
        return true;
    }

    // Pickup weapon is same as this weapon, so see if we can carry another
    if (Class == Item.InventoryType && WeaponPickup(Item) != none)
    {
        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            if (AmmoClass[i] != none && AmmoCharge[i] < MaxAmmo(i) && WeaponPickup(Item).AmmoAmount[i] > 0)
            {
                AddAmmo(WeaponPickup(Item).AmmoAmount[i], i);

                // Need to do this here as we're going to prevent a new weapon pick up, so the pickup won't give a screen message or destroy/respawn itself
                Item.AnnouncePickup(Pawn(Owner));
                Item.SetRespawn();

                break;
            }
        }

        return true; // prevents pick up, as already have weapon, & stops checking rest of Inventory chain
    }

    // Didn't do any pick up for this weapon, so pass this query on to the next item in the Inventory chain
    // If we've reached the last Inventory item, returning false will allow pick up of the weapon
    return Inventory != none && Inventory.HandlePickupQuery(Item);
}

defaultproperties
{
    FireModeClass(0)=class'DH_Equipment.DHShovelBuildFireMode'
    FireModeClass(1)=class'DH_Equipment.DHShovelMeleeFire'

    ItemName="Shovel"
    InventoryGroup=7
    GroupOffset=0
    Priority=4 // this should be higher than any other weapon on InventoryGroup=4, raising this higher than 8 will require to raise priority on other weapons
    bCanThrow=false

    DisplayFOV=80.0
    bCanSway=false

    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"

    AIRating=0.0
    CurrentRating=0.0
}
