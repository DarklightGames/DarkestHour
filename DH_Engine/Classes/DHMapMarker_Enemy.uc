//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHMapMarker_Enemy extends DHMapMarker
    abstract;

// Allow squad leaders their assistants to mark enemy positions.
static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    return PRI != none && (PRI.IsSquadLeader() || PRI.bIsSquadAssistant);
}

defaultproperties
{
    IconColor=(R=255,G=0,B=0,A=255)
    GroupIndex=1
}

