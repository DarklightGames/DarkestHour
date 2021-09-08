//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Squad extends DHMapMarker
    abstract;

// Only allow squad leader to mark squad orders.
static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    return PRI != none && PRI.IsSquadLeader();
}

defaultproperties
{
    bIsSquadSpecific=true
    GroupIndex=0
    bIsUnique=true
    bShouldOverwriteGroup=true
    bShouldShowOnCompass=true
}
