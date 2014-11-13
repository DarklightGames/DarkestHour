//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHVehicleSayMessage extends DHStringMessage;

//=============================================================================
// Variables
//=============================================================================

var Color           VehicleMessageColor;

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


    LocationName = RelatedPRI_1.GetLocationName();

    Canvas.SetDrawColor(default.VehicleMessageColor.R,default.VehicleMessageColor.G,default.VehicleMessageColor.B,default.VehicleMessageColor.A);

    Canvas.DrawText(RelatedPRI_1.PlayerName$" ", false);
    Canvas.SetPos(Canvas.CurX, Canvas.CurY - YL);

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
    optional string MessageString
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
// GetConsoleColor
//-----------------------------------------------------------------------------

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, int AlliedNationID, bool bSimpleColours)
{
    if ((RelatedPRI_1 == none) || (RelatedPRI_1.Team == none))
        return default.DrawColor;

    return default.VehicleMessageColor;
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     VehicleMessageColor=(B=170,G=30,R=170,A=255)
     MessagePrefix="*VEHICLE* "
     bComplexString=true
     bBeep=true
}
