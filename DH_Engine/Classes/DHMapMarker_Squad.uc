//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapMarker_Squad extends DHMapMarker
    abstract;

// Only allow squad leader to mark squad orders.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    return PRI != none && PRI.IsSquadLeader();
}
    
// Only allow squad leader to remove squad orders.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return PRI != none && PRI.IsSquadLeader() && Marker.SquadIndex == PRI.SquadIndex;
}

// Allow anyone in the squad to see the marker.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return Marker.SquadIndex == PRI.SquadIndex;
}

defaultproperties
{
    bIsSquadSpecific=true
    GroupIndex=0
    bIsUnique=true
    bShouldOverwriteGroup=true
    bShouldShowOnCompass=true
}
