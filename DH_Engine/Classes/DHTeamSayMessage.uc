//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHTeamSayMessage extends DHStringMessage;

static function string AssembleString(
    HUD myHUD,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional string MessageString
    )
{
    if (RelatedPRI_1 == none)
        return "";

    return default.MessagePrefix$RelatedPRI_1.PlayerName@":"@MessageString;
}

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, int AlliedNationID, bool bSimpleColours)
{
    if ((RelatedPRI_1 == none) || (RelatedPRI_1.Team == none))
        return default.DrawColor;

    if (RelatedPRI_1.Team.TeamIndex == 0)
        return default.GermanColour;
    else if (RelatedPRI_1.Team.TeamIndex == 1)
    {
        if (bSimpleColours || AlliedNationID == 1)
            return default.BritishColour;
        else if (AlliedNationID == 2)
            return default.CanadianColour;
        else
            return default.USColour;
    }
    else
        return default.DrawColor;
}

defaultproperties
{
     GermanColour=(B=80,G=80,R=200,A=255)
     USColour=(B=75,G=170,R=85,A=255)
     BritishColour=(B=190,G=140,R=64,A=255)
     CanadianColour=(B=20,G=155,R=160,A=255)
     MessagePrefix="*TEAM* "
     bComplexString=true
     bBeep=true
}
