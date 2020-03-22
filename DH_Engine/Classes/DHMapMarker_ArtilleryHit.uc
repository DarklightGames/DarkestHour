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

static function FindClosestArtilleryRequest(DHPlayer PC,
                                            out DHPlayer.ArtilleryHitInfo HitInfo, 
                                            array<DHGameReplicationInfo.MapMarker> MapMarkers, 
                                            class<DHMapMarker_FireSupport> RequestClass, 
                                            vector WorldLocation,
                                            int ElapsedTime)
{
    local DHGameReplicationInfo.MapMarker Marker;
    local int i, ClosestArtilleryRequest;
    local float MinimumDistance, Distance;
    local DHPlayerReplicationInfo PRI;
    local string SquadName;

    ClosestArtilleryRequest = -1;
    MinimumDistance = class'UFloat'.static.Infinity();
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    Log("MapMarkers.Length: " $ MapMarkers.Length);

    for(i = 0; i < MapMarkers.Length; i++)
    {
        Marker = MapMarkers[i];
        Log("i=" $ i);
        Log("Marker.MapMarkerClass=" $ Marker.MapMarkerClass $ ", RequestClass=" $ RequestClass);
        Log("Marker.ExpiryTime=" $ Marker.ExpiryTime);
        Log("Marker.MapMarkerClass.static.CanSeeMarker(PRI, Marker)=" $ Marker.MapMarkerClass.static.CanSeeMarker(PRI, Marker));
        if(Marker.MapMarkerClass == RequestClass
            && (Marker.ExpiryTime == -1 || Marker.ExpiryTime > ElapsedTime)
            && Marker.MapMarkerClass.static.CanSeeMarker(PRI, Marker))
        {
            Marker.WorldLocation.Z = 0.0;
            Log(Marker.MapMarkerClass $ ", comparing Marker.WorldLocation: " $ Marker.WorldLocation $ " with WorldLocation:" $ WorldLocation);
            Distance = VSize(Marker.WorldLocation - WorldLocation);
            if(MinimumDistance > Distance)
            {
                ClosestArtilleryRequest = i;
                MinimumDistance = Distance;
            }
        }
    }
    HitInfo.ClosestArtilleryRequestIndex = ClosestArtilleryRequest;
    HitInfo.ClosestArtilleryRequestLocation = MapMarkers[ClosestArtilleryRequest].WorldLocation;
    Log("ClosestArtilleryRequest: " $ ClosestArtilleryRequest);
    if(ClosestArtilleryRequest != -1)
    {
        Log("The closest was " $ MapMarkers[ClosestArtilleryRequest].MapMarkerClass $ " (squad " $ MapMarkers[ClosestArtilleryRequest].SquadIndex $ ")");
    }
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
    GroupIndex=6
    OverwritingRule = UNIQUE_PER_GROUP
    Scope=PERSONAL
    LifetimeSeconds=30 // 30 seconds
}
