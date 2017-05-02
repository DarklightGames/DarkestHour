//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionErrorMessage extends ROGameMessage
    abstract;

var localized array<string> ErrorMessages;

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHConstructionProxy CP;
    local string Result;

    Result = default.ErrorMessages[S];

    CP = DHConstructionProxy(OptionalObject);

    if (CP != none)
    {
        Result = Repl(Result, "{0}", CP.ConstructionClass.static.GetMenuName(CP.PlayerOwner));
        Result = Repl(Result, "{1}", int(CP.ConstructionClass.default.DuplicateDistanceInMeters));
    }

    return Result;
}

defaultproperties
{
    ErrorMessages(2)="No ground."
    ErrorMessages(3)="The ground is too steep here."
    ErrorMessages(4)="A {0} cannot be placed in water."
    ErrorMessages(5)="You cannot construct a {0} at this location."
    ErrorMessages(6)="Not enough room."
    ErrorMessages(7)="{0} must be placed on earthen terrain."
    ErrorMessages(8)="Too close to an existing {0} (must be {1}m away)."
    ErrorMessages(9)="You cannot construct a {0} in a minefield."
    ErrorMessages(10)="You cannot construct a {0} near a spawn point."
    ErrorMessages(11)="You cannot construct a {0} indoors."
    ErrorMessages(12)="You cannot construct a {0} inside an objective."
    ErrorMessages(13)="Your team cannot construct any more {0} (limit reached)."
    ErrorMessages(14)="There are no supply caches within {2} meters."
    ErrorMessages(15)="There are insufficient supplies to create this construction."
        ERROR_TeamLimit,            // Limit reached for this type of construction
    ERROR_NoSupplies,           // Not within range of any supply caches
    ERROR_InsufficientSupply,   // Not enough supplies to build this construction
    ERROR_RestrictedType,       // Restricted construction type (can't build on this map!)
}

