//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHCommandSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    // TODO: show name of squad here too, maybe.
    return default.MessagePrefix @ RelatedPRI_1.PlayerName @ ":" @ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White) $ MessageString;
}

static function color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, int AlliedNationID, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    MessagePrefix="[COMMAND]"
    bComplexString=true
    bBeep=true
    DrawColor=(R=225,G=105,B=45,A=255)
}

