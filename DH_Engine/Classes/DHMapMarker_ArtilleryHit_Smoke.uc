//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit_Smoke extends DHMapMarker_ArtilleryHit
    abstract;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    CalculateHitMarkerVisibility(PC,
                                 PC.SmokeHitInfo,
                                 class'DHMapMarker_FireSupport_Smoke',
                                 Marker.WorldLocation);
}

static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return PRI != none &&
           DHPlayer(PRI.Owner).IsArtilleryRole() &&
           DHPlayer(PRI.Owner).SmokeHitInfo.bIsWithinRadius;
}

defaultproperties
{
    MarkerName="Artillery hit (smoke)"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.move'
}
