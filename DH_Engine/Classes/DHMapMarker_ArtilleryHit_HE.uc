//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit_HE extends DHMapMarker_ArtilleryHit abstract;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    CalculateHitMarkerVisibility(PC,
                                PC.HEHitInfo,
                                class'DHMapMarker_FireSupport_HE', 
                                Marker.WorldLocation);
}

static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return PRI != none && DHPlayer(PRI.Owner).IsArtilleryRole() 
            && DHPlayer(PRI.Owner).HEHitInfo.bIsWithinRadius;
}

defaultproperties
{
    MarkerName="Artillery hit (HE)"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Fire'
}

