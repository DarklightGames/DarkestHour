//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponPickupTouchMessage extends ROTouchMessagePlus;

var localized string TouchMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController PC;
    local string S;

    PC = RelatedPRI_1.Level.GetLocalPlayerController();
    
    S = default.TouchMessage;

    if (OptionalObject != none)
    {
        S = Repl(S, "{item}", class'DHPlayer'.static.GetInventoryName(class<Inventory>(OptionalObject)));
    }

    S = Repl(S, "{input}", "[%USE%]");

    return class'DarkestHourGame'.static.ParseLoadingHintNoColor(S, PC);
}

defaultproperties
{
    TouchMessage="Press {input} to pick up {item}"
}
