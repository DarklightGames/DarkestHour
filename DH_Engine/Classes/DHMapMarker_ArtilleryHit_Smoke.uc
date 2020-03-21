//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit_Smoke extends DHMapMarker_ArtilleryHit abstract;

static function AddMarker(DHPlayer PC, float MapLocationX, float MapLocationY)
{
    local DHPlayer.ArtilleryHitInfo HitInfo;
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local DHGameReplicationInfo GRI;
    local vector WorldLocation;

    if(!PC.IsArtilleryRole())
        return;

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    GRI.GetMapMarkers(PC, MapMarkers, PC.GetTeamNum());
    WorldLocation = GRI.GetWorldCoords(MapLocationX, MapLocationY);

    FindClosestArtilleryRequest(PC,
                                HitInfo, 
                                MapMarkers,
                                class'DHMapMarker_FireSupport_Smoke', 
                                WorldLocation,
                                GRI.ElapsedTime);
    PC.SmokeHitInfo = HitInfo;
    PC.AddPersonalMarker(default.Class, MapLocationX, MapLocationY);
}

defaultproperties
{
    MarkerName="Artillery hit (smoke)"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.move'
}

