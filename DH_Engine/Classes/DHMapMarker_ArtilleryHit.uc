//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit extends DHMapMarker
    abstract;

var DHPlayer        Controller; // the guy who fired the projectile
var vector          Location;
var float           Time;
var int             ClosestFireRequestIndex; // this can be used for quickly finding nearest fire requests later on


// Only allow artillery roles to place artillery hits.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);
    return PRI != none && (PC.IsArtilleryRole());
}

// Disable for everyone - artillery hits can't be removed from the map.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return false;
}

// Only allow artillery roles to see artillery hits
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);
    return PRI != none && (PC.IsArtilleryRole());
}

defaultproperties
{
    MarkerName="Artillery hit"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Attack'
    IconColor=(R=204,G=255,B=0,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    bIsUnique=true
    bIsPersonal = true
    bIsSquadSpecific=false
    bIsVisibleToTeam=false
    LifetimeSeconds=30 // 30 seconds
}
