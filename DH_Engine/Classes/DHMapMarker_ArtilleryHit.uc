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

static function CalculateHitMarkerVisibility(out DHPlayer PC,
                                            out DHPlayer.ArtilleryHitInfo HitInfo, 
                                            class<DHMapMarker_FireSupport> RequestClass,
                                            vector WorldLocation)
{
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local DHGameReplicationInfo GRI;
    local DHGameReplicationInfo.MapMarker Marker;
    local int i, ClosestArtilleryRequest, ElapsedTime;
    local float MinimumDistance, Distance;
    local DHPlayerReplicationInfo PRI;

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    ClosestArtilleryRequest = -1;
    MinimumDistance = class'UFloat'.static.Infinity();
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    ElapsedTime = GRI.ElapsedTime;
    GRI.GetMapMarkers(PC, MapMarkers, PC.GetTeamNum());

    for(i = 0; i < MapMarkers.Length; i++)
    {
        Marker = MapMarkers[i];
        if(Marker.MapMarkerClass == RequestClass
            && (Marker.ExpiryTime == -1 || Marker.ExpiryTime > ElapsedTime)
            && Marker.MapMarkerClass.static.CanSeeMarker(PRI, Marker))
        {
            Marker.WorldLocation.Z = 0.0;
            Distance = VSize(Marker.WorldLocation - WorldLocation);
            if(MinimumDistance > Distance)
            {
                ClosestArtilleryRequest = i;
                MinimumDistance = Distance;
            }
        }
    }
    HitInfo.ClosestArtilleryRequestIndex = ClosestArtilleryRequest;
    HitInfo.bIsHitVisible = (MinimumDistance < RequestClass.default.HitVisibilityRadius);
    if(ClosestArtilleryRequest != -1 && MinimumDistance < RequestClass.default.HitVisibilityRadius)
    {
        HitInfo.ClosestArtilleryRequestLocation = MapMarkers[ClosestArtilleryRequest].WorldLocation;
    }
}

defaultproperties
{
    MarkerName="Artillery hit"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Attack'
    IconColor=(R=204,G=255,B=0,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=6
    OverwritingRule = UNIQUE_PER_GROUP
    Scope=PERSONAL
    LifetimeSeconds=30 // 30 seconds
}
