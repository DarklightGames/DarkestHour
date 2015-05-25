//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSayDeadMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    if (RelatedPRI_1.bIsSpectator)
    {
        return default.SpecPrefix @ RelatedPRI_1.PlayerName $ ":" @ MessageString;
    }
    else
    {
        return default.MessagePrefix @ RelatedPRI_1.PlayerName $ ":" @ MessageString;
    }
}

defaultproperties
{
    MessagePrefix="(DEAD)"
    SpecPrefix="(SPECTATOR)"
    bComplexString=true
    bBeep=true
}
