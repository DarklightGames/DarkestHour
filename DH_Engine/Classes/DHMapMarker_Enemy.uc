//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Enemy extends DHMapMarker
    abstract;

// Allow squad leaders, their assistants, and patrons to mark enemy positions.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    return PRI != none && (PRI.IsSLorASL() || PRI.IsPatron());
}

// Allow squad leaders, their assistants, and patrons to remove map markers.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return PRI != none && (PRI.IsSLorASL() || PRI.IsPatron());
}

// Allow everyone in the team to see the marker.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return PRI != none;
}

defaultproperties
{
    IconColor=(R=255,G=0,B=0,A=255)
    GroupIndex=1
}
