//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    return RelatedPRI_1.PlayerName $ ":" @ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White) $ MessageString;
}

defaultproperties
{
    bComplexString=true
    bBeep=true
}
