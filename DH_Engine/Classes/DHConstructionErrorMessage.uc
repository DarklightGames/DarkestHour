//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstructionErrorMessage extends LocalMessage
    abstract;

var localized array<string> ErrorMessages;

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHConstructionProxy CP;
    local string Result;

    CP = DHConstructionProxy(OptionalObject);

    if (CP.ProxyError.Type == ERROR_Custom)
    {
        Result = CP.ProxyError.CustomErrorString;
    }
    else
    {
        Result = default.ErrorMessages[int(CP.ProxyError.Type)];
    }

    Result = Repl(Result, "{name}", CP.ConstructionClass.static.GetMenuName(CP.GetContext()));
    Result = Repl(Result, "{verb}", CP.ConstructionClass.default.ConstructionVerb);
    Result = Repl(Result, "{integer}", CP.ProxyError.OptionalInteger);
    Result = Repl(Result, "{string}", CP.ProxyError.OptionalString);

    return Result;
}

static function RenderComplexMessage(
    Canvas Canvas,
    out float XL,
    out float YL,
    optional String MessageString,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local float X, Y;

    X = Canvas.CurX;
    Y = Canvas.CurY;

    Canvas.DrawColor = class'UColor'.default.Black;
    Canvas.SetPos(X + 1.0, Y + 1.0);
    Canvas.DrawText(MessageString);

    Canvas.DrawColor = default.DrawColor;
    Canvas.SetPos(X, Y);
    Canvas.DrawText(MessageString);
}

defaultproperties
{
    bFadeMessage=false
    bIsUnique=true
    bIsConsoleMessage=false
    bComplexString=true
    DrawColor=(R=255,G=255,B=255,A=255)
    FontSize=-2
    Lifetime=0.25
    PosY=0.80
    ErrorMessages(2)="You must {verb} a {name} on solid ground."
    ErrorMessages(3)="The ground is too steep here to {verb} a {name}."
    ErrorMessages(4)="You cannot {verb} a {name} in water."
    ErrorMessages(5)="You cannot {verb} a {name} at this location."
    ErrorMessages(6)="Not enough room here to {verb} a {name}."
    ErrorMessages(7)="You must {verb} a {name} on earthen terrain."
    ErrorMessages(8)="Too close to an existing friendly {name}, it must be {integer}m further away."
    ErrorMessages(9)="Too close to an existing enemy {name}, it must be {integer}m further away."
    ErrorMessages(10)="You cannot {verb} a {name} in a minefield."
    ErrorMessages(11)="You cannot {verb} a {name} near a spawn point."
    ErrorMessages(12)="You cannot {verb} a {name} indoors."
    ErrorMessages(13)="You cannot {verb} a {name} inside an objective."
    ErrorMessages(14)="Your team cannot {verb} any more {name} (limit reached: {integer})."
    ErrorMessages(15)="There are no supply caches within {integer} meters."   // TODO: this was never tested!
    ErrorMessages(16)="There are insufficient supplies to {verb} a {name}."
    ErrorMessages(17)="You cannot {verb} a {name} on this surface."
    ErrorMessages(18)="The ground is too hard to {verb} a {name} at this location."
    ErrorMessages(19)=""    // ERROR_RestrictedType (will never be used)
    ErrorMessages(20)="You must have {integer} members in your squad to {verb} a {name}."
    ErrorMessages(21)="You cannot {verb} a {name} while you are busy."
    ErrorMessages(22)="Too close to an objective ({string}), it must be {integer}m further away."
    ErrorMessages(23)="Too close to an uncontrolled objective ({string}), it must be {integer}m further away."
    ErrorMessages(24)="You must {verb} a {name} within {integer}m of a friendly {string}";
    ErrorMessages(25)="You cannot {verb} a {name} in enemy territory";
    ErrorMessages(26)="There are no more {name} available";
}

