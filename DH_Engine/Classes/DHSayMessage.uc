//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHSayMessage extends DHStringMessage;

static function RenderComplexMessage(
    Canvas Canvas,
    out float XL,
    out float YL,
    optional string MessageString,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    if (RelatedPRI_1 == none)
        return;

    if (RelatedPRI_1.Team.TeamIndex == 0)
        Canvas.DrawColor = default.GermanColour;
    else
        Canvas.DrawColor = default.USColour;

    Canvas.DrawText(RelatedPRI_1.PlayerName$": ", false);
    Canvas.SetPos(Canvas.CurX, Canvas.CurY - YL);
    Canvas.DrawColor = default.DrawColor;
    Canvas.DrawText(MessageString, false);
}

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
    return RelatedPRI_1.PlayerName$": "$MessageString;
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
    bComplexString=true
    bBeep=true
}
