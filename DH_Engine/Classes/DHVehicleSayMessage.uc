//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHVehicleSayMessage extends DHLocalMessage;

var Color           VehicleMessageColor;

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

    return default.VehicleMessageColor;
}

defaultproperties
{
    VehicleMessageColor=(B=170,G=30,R=170,A=255)
    MessagePrefix="*VEHICLE* "
    bComplexString=true
    bBeep=true
}
