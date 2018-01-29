//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHWeaponPickupTouchMessage extends ROTouchMessagePlus;

// Provides weapon pick up screen message, relying on pickup's NotifyParameters being passed as OptionalObject, so we can display both the use/pick up key & weapon name
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local Object O;
    local TreeMap_string_Object OM;
    local class<Inventory> InventoryClass;
    local PlayerController PC;

    OM = TreeMap_string_Object(OptionalObject);

    if (OM != none)
    {
        OM.Get("InventoryClass", O);
        InventoryClass = class<Inventory>(O);

        OM.Get("Controller", O);
        PC = PlayerController(O);
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
