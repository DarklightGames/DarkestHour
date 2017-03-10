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
        Result = Repl(Result, "{0}", CP.ConstructionClass.default.MenuName);
    }

    return Result;
}

defaultproperties
{
    ErrorMessages(0)=""
    ErrorMessages(1)=""
    ErrorMessages(2)="No ground."
    ErrorMessages(3)="The ground is too steep here."
    ErrorMessages(4)="A {0} cannot be placed in water."
    ErrorMessages(5)="You cannot construct a {0} at this location."
    ErrorMessages(6)="Not enough room."
    ErrorMessages(7)="{0} must be placed on earthen terrain."
}

