//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHLocalMessage extends LocalMessage;

var()   color       GermanColour;
var()   color       USColour;
var()   color       BritishColour;
var()   color       CanadianColour;

var localized   string  MessagePrefix;
var localized   string  SpecPrefix;

static function string AssembleString(
    HUD myHUD,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional string MessageString
    )
{
    return MessageString;
}

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, int AlliedNationID, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    bIsSpecial=false
    Lifetime=8
    PosY=0.700000
}
