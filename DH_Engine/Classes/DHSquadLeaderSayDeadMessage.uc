//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSquadLeaderSayDeadMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    return default.MessagePrefix @ RelatedPRI_1.PlayerName @ ":" @ MessageString;
}

static function color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    DrawColor=(R=0,G=204,B=204,A=255)
    MessagePrefix="(DEAD) [SQUAD LEADER]"
    bComplexString=true
    bBeep=true
}

