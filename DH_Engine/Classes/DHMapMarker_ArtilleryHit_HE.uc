//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit_HE extends DHMapMarker_ArtilleryHit abstract;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer.ArtilleryHitInfo HitInfo;
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local DHGameReplicationInfo GRI;
    local vector WorldLocation;

    if(!PC.IsArtilleryRole())
        return;

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    GRI.GetMapMarkers(PC, MapMarkers, PC.GetTeamNum());
    WorldLocation = Marker.WorldLocation;

    FindClosestArtilleryRequest(PC,
                                HitInfo, 
                                MapMarkers,
                                class'DHMapMarker_FireSupport_HE', 
                                WorldLocation,
                                GRI.ElapsedTime);
    PC.HEHitInfo = HitInfo;
}

defaultproperties
{
    MarkerName="Artillery hit (HE)"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Fire'
}

