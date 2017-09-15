//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstructionErrorMessage extends ROGameMessage
    abstract;

var localized array<string> ErrorMessages;

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHConstructionProxy CP;
    local string Result;

    CP = DHConstructionProxy(OptionalObject);

    if (CP != none)
    {
        Result = default.ErrorMessages[int(CP.ProxyError.Type)];
        Result = Repl(Result, "{0}", CP.ConstructionClass.static.GetMenuName(CP.PlayerOwner));
        Result = Repl(Result, "{1}", CP.ProxyError.OptionalInteger);
        Result = Repl(Result, "{2}", CP.ProxyError.OptionalString);
    }

    return Result;
}

defaultproperties
{
    ErrorMessages(2)="No ground."
    ErrorMessages(3)="The ground is too steep here."
    ErrorMessages(4)="You cannot construct a {0} in water."
    ErrorMessages(5)="You cannot construct a {0} at this location."
    ErrorMessages(6)="Not enough room."
    ErrorMessages(7)="{0} must be constructed on earthen terrain."
    ErrorMessages(8)="Too close to an existing friendly {0}, it must be {1}m further away."
    ErrorMessages(9)="Too close to an existing enemy {0}, it must be {1}m further away."
    ErrorMessages(10)="You cannot construct a {0} in a minefield."
    ErrorMessages(11)="You cannot construct a {0} near a spawn point."
    ErrorMessages(12)="You cannot construct a {0} indoors."
    ErrorMessages(13)="You cannot construct a {0} inside an objective."
    ErrorMessages(14)="Your team cannot construct any more {0} (limit reached)."
    ErrorMessages(15)="There are no supply caches within {1} meters."   // TODO: this was never tested!
    ErrorMessages(16)="There are insufficient supplies to create this construction."
    ErrorMessages(17)="You cannot construct a {0} on this surface."
    ErrorMessages(18)="The ground is too hard at this location."
    ErrorMessages(19)="You must have {1} members in your squad to construct a {0}."
}

