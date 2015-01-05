//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHATLoadFailMessage extends ROCriticalMessage;

var localized string  CantLoad;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return RelatedPRI_1.PlayerName @ default.CantLoad;
}

defaultproperties
{
    CantLoad="Must be deployed to be reloaded"
}
