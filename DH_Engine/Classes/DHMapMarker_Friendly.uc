//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Friendly extends DHMapMarker
    abstract;

// Allow squad leaders and their assistants to mark friendly markers.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    return PRI != none && PRI.IsSLorASL();
}

// Allow squad leaders and their assistants to remove friendly markers.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return PRI != none && PRI.IsSLorASL();
}

// Allow everyone on the team to see friendly markers.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return PRI != none;
}

defaultproperties
{
    IconColor=(R=0,G=255,B=0,A=255)
    GroupIndex=2
}

