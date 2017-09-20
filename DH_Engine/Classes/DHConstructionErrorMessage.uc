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
        Result = Repl(Result, "{name}", CP.ConstructionClass.static.GetMenuName(CP.PlayerOwner));
        Result = Repl(Result, "{verb}", CP.ConstructionClass.default.ConstructionVerb);
        Result = Repl(Result, "{integer}", CP.ProxyError.OptionalInteger);
        Result = Repl(Result, "{string}", CP.ProxyError.OptionalString);
    }

    return Result;
}

defaultproperties
{
    ErrorMessages(2)="No ground."
    ErrorMessages(3)="The ground is too steep here."
    ErrorMessages(4)="You cannot {verb} a {name} in water."
    ErrorMessages(5)="You cannot {verb} a {name} at this location."
    ErrorMessages(6)="Not enough room."
    ErrorMessages(7)="You must {verb} a {name} on earthen terrain."
    ErrorMessages(8)="Too close to an existing friendly {name}, it must be {integer}m further away."
    ErrorMessages(9)="Too close to an existing enemy {name}, it must be {integer}m further away."
    ErrorMessages(10)="You cannot {verb} a {name} in a minefield."
    ErrorMessages(11)="You cannot {verb} a {name} near a spawn point."
    ErrorMessages(12)="You cannot {verb} a {name} indoors."
    ErrorMessages(13)="You cannot {verb} a {name} inside an objective."
    ErrorMessages(14)="Your team cannot {verb} any more {name} (limit reached)."
    ErrorMessages(15)="There are no supply caches within {integer} meters."   // TODO: this was never tested!
    ErrorMessages(16)="There are insufficient supplies to {verb} a {name}."
    ErrorMessages(17)="You cannot {verb} a {name} on this surface."
    ErrorMessages(18)="The ground is too hard at this location."
    ErrorMessages(19)="You must have {integer} members in your squad to construct a {name}."
}

