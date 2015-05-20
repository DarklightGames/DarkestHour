//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWeaponPickupTouchMessage extends ROTouchMessagePlus;

// Provides the weapon touch message on the player's screen, relying on the weapon class being passed as the OptionalObject
// Used with placeable weapon pickups, where leveller may have used generic class & set weapon type in editor, meaning no class default weapon type & static functions can't access weapon properties
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local ObjectMap OM;
    local class<Inventory> InventoryClass;
    local PlayerController PC;

    OM = ObjectMap(OptionalObject);

    if (OM != none)
    {
        InventoryClass = class<Inventory>(OM.Get("InventoryClass"));
        PC = PlayerController(OM.Get("Controller"));
    }

    S = class'DarkestHourGame'.static.ParseLoadingHintNoColor(class'DHWeaponPickup'.default.TouchMessage, PC);

    if (InventoryClass != none)
    {
        S = Repl(S, "{0}", InventoryClass.default.ItemName);
    }

    return S;
}

defaultproperties
{
}
