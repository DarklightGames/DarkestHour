//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTrenchMaceItem extends DHWeapon;

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
    FireModeClass(0)=class'DH_Equipment.DHTrenchMaceMeleeFire'
    
    ItemName="Trench Club"
    InventoryGroup=7
    GroupOffset=0
    Priority=4 // this should be higher than any other weapon on InventoryGroup=4, raising this higher than 8 will require to raise priority on other weapons
    bCanThrow=false

    DisplayFOV=90.0
    bCanSway=false
    
    SelectAnim="draw"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IdleAnim="idle"
    SprintStartAnim="sprint_start"
    SprintEndAnim="sprint_end"
    PutDownAnim="putaway"
    
    AIRating=0.0
    CurrentRating=0.0

    AttachmentClass=class'DHTrenchMaceAttachment'
    Mesh=SkeletalMesh'DH_Halloween_anm.trenchmace'
    Skins(2)=Texture'DH_Halloween_tex.Maces.TrenchClubTexture'
    //HighDetailOverlay=Shader'DH_Equipment_tex.Shovels.US_shovel_s'
    //bUseHighDetailOverlayIndex=true
    //HighDetailOverlayIndex=2
}