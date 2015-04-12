//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWeaponPickupTouchMessage extends ROTouchMessagePlus;

// Provides the weapon touch message on the player's screen, relying on the weapon class being passsed as the OptionalObject
// Used with placeable weapon pickups, where leveller may have used generic class & set weapon type in editor, meaning no class default weapon type & static functions can't access weapon properties
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (class<Inventory>(OptionalObject) != none)
    {
        return Repl(class'DHPlaceableWeaponPickup'.default.TouchMessage, "%w", class<Inventory>(OptionalObject).default.ItemName);
    }

    return super.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject); // fallback
}

defaultproperties
{
}
