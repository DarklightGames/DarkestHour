//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSquadSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    return default.MessagePrefix @ RelatedPRI_1.PlayerName @ ":" @ MessageString;
}

static function color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, int AlliedNationID, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    DrawColor=(R=0,G=204,B=0,A=255)
    MessagePrefix="*SQUAD*"
    bComplexString=true
    bBeep=true
}

