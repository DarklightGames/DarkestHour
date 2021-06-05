//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit extends DHMapMarker
    abstract;

var class<DHMapMarker_FireSupport_OnMap> RequestMarkerClass;

// Only allow artillery roles to place artillery hits.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.IsArtilleryOperator();
}

// Disable for everyone - artillery hits can't be removed from the map.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return false;
}

static function CalculateHitMarkerVisibility(out DHPlayer PC,
                                             vector WorldLocation)
{
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local DHGameReplicationInfo GRI;
    local DHGameReplicationInfo.MapMarker Marker;
    local int i, ClosestArtilleryRequest, ElapsedTime;
    local float MinimumDistance, Distance;
    local DHPlayerReplicationInfo PRI;
    local bool bIsMarkerAlive;

    if (PC == none)
    {
        return;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (GRI == none || PRI == none)
    {
        return;
    }

    ClosestArtilleryRequest = -1;
    MinimumDistance = class'UFloat'.static.Infinity();

    ElapsedTime = GRI.ElapsedTime;
    GRI.GetMapMarkers(PC, MapMarkers, PC.GetTeamNum());

    // Look for the closest marker that corresponds to the given RequestMarkerClass
    for (i = 0; i < MapMarkers.Length; ++i)
    {
        Marker = MapMarkers[i];

        bIsMarkerAlive = Marker.ExpiryTime == -1 || Marker.ExpiryTime > ElapsedTime;

        if ((Marker.MapMarkerClass == default.RequestMarkerClass)
          && bIsMarkerAlive
          && Marker.MapMarkerClass.static.CanSeeMarker(PRI, Marker)
          && !(PRI.IsSL() && PRI.SquadIndex == Marker.SquadIndex))
        {
            Marker.WorldLocation.Z = 0.0;
            Distance = VSize(Marker.WorldLocation - WorldLocation);

            if (MinimumDistance > Distance)
            {
                ClosestArtilleryRequest = i;
                MinimumDistance = Distance;
            }
        }
    }

    PC.ArtilleryHitInfo.ClosestArtilleryRequestIndex = ClosestArtilleryRequest;
    PC.ArtilleryHitInfo.bIsWithinRadius = (MinimumDistance < default.RequestMarkerClass.default.HitVisibilityRadius);

    if (ClosestArtilleryRequest != -1 && PC.ArtilleryHitInfo.bIsWithinRadius)
    {
        PC.ArtilleryHitInfo.ClosestArtilleryRequestLocation = MapMarkers[ClosestArtilleryRequest].WorldLocation;
        PC.ArtilleryHitInfo.ExpiryTime = MapMarkers[ClosestArtilleryRequest].ExpiryTime;
    }
    else
    {
        // to do: handle it in a better way?
        PC.ArtilleryHitInfo.ExpiryTime = 0;
    }
}

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    CalculateHitMarkerVisibility(PC, Marker.WorldLocation);
}

static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.IsArtilleryOperator() && PC.ArtilleryHitInfo.bIsWithinRadius
    && !(PC.IsSL() && PC.GetSquadIndex() != Marker.SquadIndex);
}

defaultproperties
{
    IconMaterial=MaterialSequence'DH_InterfaceArt2_tex.Artillery.HitMarker'
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=6
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=PERSONAL
    LifetimeSeconds=15 // 30 seconds
}
