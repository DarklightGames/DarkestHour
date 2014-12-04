//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHSayDeadMessage extends DHStringMessage;

static function string AssembleString(
    HUD myHUD,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional string MessageString
    )
{
    if (RelatedPRI_1 == none)
        return "";
    if (RelatedPRI_1.PlayerName == "")
        return "";

    if (RelatedPRI_1.bIsSpectator)
        return default.SpecPrefix$RelatedPRI_1.PlayerName$": "$MessageString;
    else
        return default.MessagePrefix$RelatedPRI_1.PlayerName$": "$MessageString;
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
     GermanColour=(B=55,G=55,R=150,A=255)
     USColour=(B=60,G=125,R=65,A=255)
     BritishColour=(B=140,G=105,R=50,A=255)
     CanadianColour=(B=20,G=120,R=125,A=255)
     MessagePrefix="(DEAD) "
     SpecPrefix="(SPECTATOR) "
     bComplexString=true
     bBeep=true
}
