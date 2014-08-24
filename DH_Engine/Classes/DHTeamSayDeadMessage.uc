//=============================================================================
// DHTeamSayDeadMessage
//=============================================================================

class DHTeamSayDeadMessage extends DHStringMessage;

//=============================================================================
// Variables
//=============================================================================

var Color       GermanColour;
var Color       USColour;
var Color       BritishColour;
var Color       CanadianColour;

var localized   string  MessagePrefix;

//=============================================================================
// Functions
//=============================================================================

//-----------------------------------------------------------------------------
// RenderComplexMessage
//-----------------------------------------------------------------------------

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
    local string LocationName;

    if (RelatedPRI_1 == none)
        return;

    if (RelatedPRI_1.Team.TeamIndex == 0)
        Canvas.DrawColor = default.GermanColour;
    else
        Canvas.DrawColor = default.USColour;

/*  if (RelatedPRI_1.Team.TeamIndex == 0)
        Canvas.SetDrawColor(192,64,64,255); //DrawColor = default.RussianColor;
    else
        Canvas.SetDrawColor(64,128,128,255); //DrawColor = default.GermanColor;
*/

    Canvas.DrawText(default.MessagePrefix$RelatedPRI_1.PlayerName$" ", false);
    Canvas.SetPos(Canvas.CurX, Canvas.CurY - YL);
    LocationName = RelatedPRI_1.GetLocationName();

    if (LocationName != "")
        Canvas.DrawText("("$LocationName$"):", false);
    else
        Canvas.DrawText(": ", false);

    Canvas.SetPos(Canvas.CurX, Canvas.CurY - YL);
    Canvas.SetDrawColor(255,255,255,255); //DrawColor = default.DrawColor;
    Canvas.DrawText(MessageString, false);
}

//-----------------------------------------------------------------------------
// AssembleString
//-----------------------------------------------------------------------------

static function string AssembleString(
    HUD myHUD,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional String MessageString
    )
{
    local string LocationName;

    if (RelatedPRI_1 == none)
        return "";
    LocationName = RelatedPRI_1.GetLocationName();
    if (LocationName == "")
        return default.MessagePrefix$RelatedPRI_1.PlayerName@":"@MessageString;
    else
        return default.MessagePrefix$RelatedPRI_1.PlayerName$" ("$LocationName$"): "$MessageString;
}

//-----------------------------------------------------------------------------
// GetDHConsoleColor
//-----------------------------------------------------------------------------

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

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     GermanColour=(B=55,G=55,R=150,A=255)
     USColour=(B=60,G=125,R=65,A=255)
     BritishColour=(B=140,G=105,R=50,A=255)
     CanadianColour=(B=20,G=120,R=125,A=255)
     MessagePrefix="(DEAD) *PLATOON* "
     bComplexString=true
     bBeep=true
}
