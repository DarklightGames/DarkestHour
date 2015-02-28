//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleDestroyedMessage extends DHLocalMessage;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    return MessageString;
}

defaultproperties
{
    DrawColor=(R=255,G=94,B=22)
    bComplexString=true
    bBeep=true
}

