//=============================================================================
// DHTeamSayMessage
//=============================================================================

class DHTeamSayMessage extends DHStringMessage;

//=============================================================================
// Variables
//=============================================================================

var	Color		GermanColour;
var	Color		USColour;
var	Color		BritishColour;
var	Color		CanadianColour;

var	localized	string	MessagePrefix;

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

/*	if (RelatedPRI_1.Team.TeamIndex == 0)
		Canvas.SetDrawColor(64,128,128,255); //DrawColor = default.GermanColor;
	else
		Canvas.SetDrawColor(192,64,64,255); //DrawColor = default.RussianColor;
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
     GermanColour=(B=80,G=80,R=200,A=255)
     USColour=(B=75,G=170,R=85,A=255)
     BritishColour=(B=190,G=140,R=64,A=255)
     CanadianColour=(B=20,G=155,R=160,A=255)
     MessagePrefix="*PLATOON* "
     bComplexString=true
     bBeep=true
}
