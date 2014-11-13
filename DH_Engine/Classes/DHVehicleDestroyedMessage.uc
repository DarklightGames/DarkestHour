//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHVehicleDestroyedMessage extends DHStringMessage;

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
    Canvas.DrawColor = default.DrawColor;
    Canvas.SetPos(Canvas.CurX, Canvas.CurY - YL);
    Canvas.DrawText(MessageString, false);
}

static function string AssembleString(
    HUD myHUD,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional string MessageString
    )
{
    return MessageString;
}

defaultproperties
{
    DrawColor=(R=255,G=94,B=22)
    bComplexString=true
    bBeep=true
}

