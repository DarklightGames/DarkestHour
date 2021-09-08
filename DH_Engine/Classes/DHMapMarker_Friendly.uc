//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Friendly extends DHMapMarker
    abstract;

// Allow squad leaders and their assistants to mark friendly markers.
static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    return PRI != none && PRI.IsSLorASL();
}

defaultproperties
{
    IconColor=(R=0,G=255,B=0,A=255)
    GroupIndex=2
}

