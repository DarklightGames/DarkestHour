//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit extends DHMapMarker
    abstract;

// Only allow artillery roles to place artillery hits.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    return PRI != none && DHPlayer(PRI.Owner).IsArtilleryRole();
}

// Disable for everyone - artillery hits can't be removed from the map.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return false;
}

// Only allow artillery roles to see artillery hits.
// Keep in mind that ArtilleryHits are to be used as personal marker, so nobody else than the shooter will see them 
// except for the mortar operators/Priest crewmen.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return PRI != none && DHPlayer(PRI.Owner).IsArtilleryRole();
}

defaultproperties
{
    MarkerName="Artillery hit"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Attack'
    IconColor=(R=204,G=255,B=0,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    bIsUnique=true
    bShouldOverwriteGroup=true
    GroupIndex=6Z
    Scope=PERSONAL
    LifetimeSeconds=30 // 30 seconds
}
