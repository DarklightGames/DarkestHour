//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrokenBottleItem extends DHWeapon;

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
    FireModeClass(0)=class'DH_Equipment.DHBrokenBottleMeleeFire' // for some odd reason, having just the singular firemodeclass causes tweening issues with the weapons bash animations
    FireModeClass(1)=class'DH_Equipment.DHBrokenBottleMeleeFire' // hacky fix but duplicating the firemodeclass fixes this?
    PickupClass=class'DH_Equipment.DHBrokenBottlePickup'
    ItemName="Vino Rosso 'Bass-net' 2009 Vintage"
    InventoryGroup=1
    GroupOffset=0
    Priority=4 // this should be higher than any other weapon on InventoryGroup=4, raising this higher than 8 will require to raise priority on other weapons
    bCanThrow=true
    

    DisplayFOV=90.0
    bCanSway=false

    SelectAnim="draw_bottle"
    CrawlStartAnim="crawl_in_bottle"
    CrawlEndAnim="crawl_out_bottle"
    IdleAnim="idle_bottle"
    SprintStartAnim="sprint_start_bottle"
    SprintEndAnim="sprint_end_bottle"
    PutDownAnim="put_away_bottle"
    CrawlForwardAnim="crawlF_bottle"
    CrawlBackwardAnim="crawlB_bottle"
  
    
    AIRating=0.0
    CurrentRating=0.0

    SprintStartAnimRate=1
    SprintEndAnimRate=1
    SprintLoopAnimRate=1

    bUsesFreeAim=true
    FreeAimRotationSpeed=2.0

    AttachmentClass=class'DHBrokenBottleAttachment'
    Mesh=SkeletalMesh'DH_Halloween_anm.BrokenBottle'
    //Skins(0)=Texture'DH_Halloween_tex.Maces.BrokenBottleTexture'
    //Skins(1)=Texture'DH_Halloween_tex.Maces.BrokenBottleTexture'
}