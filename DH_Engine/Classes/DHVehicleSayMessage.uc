//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    return default.MessagePrefix @ RelatedPRI_1.PlayerName @ ":" @ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White) $ MessageString;
}

static function color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    DrawColor=(B=170,G=30,R=170,A=255)
    MessagePrefix="[VEHICLE]"
    bComplexString=true
    bBeep=true
}
