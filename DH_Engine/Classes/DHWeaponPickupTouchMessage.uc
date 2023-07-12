//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponPickupTouchMessage extends ROTouchMessagePlus;

// Provides weapon pick up screen message, relying on pickup's NotifyParameters being passed as OptionalObject, so we can display both the use/pick up key & weapon name
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local DHWeaponPickupTouchMessageParameters P;

    P = DHWeaponPickupTouchMessageParameters(OptionalObject);
    S = class'DHWeaponPickup'.default.TouchMessage;

    if (P != none)
    {
        if (P.PlayerController != none)
        {
            S = class'DarkestHourGame'.static.ParseLoadingHintNoColor(S, P.PlayerController);
        }

        if (P.InventoryClass != none)
        {
            S = Repl(S, "{0}", P.InventoryClass.default.ItemName);
        }
    }

    return S;
}
