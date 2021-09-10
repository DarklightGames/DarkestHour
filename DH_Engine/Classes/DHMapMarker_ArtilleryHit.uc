//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit extends DHMapMarker
    abstract;

var int VisibilityRange;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local DHGameReplicationInfo GRI;
    local int i, ClosestArtilleryRequest, ElapsedTime;
    local float MinimumDistance, Distance;
    local DHPlayerReplicationInfo PRI;

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

    // Look for the selected artillery target
    // Also in case the operator is also a spotter: do not let them shoot if the shells land on their squad's marker
    for (i = 0; i < MapMarkers.Length; ++i)
    {
        Marker = MapMarkers[i];

        if (!GRI.IsMapMarkerExpired(Marker)
          && Marker.MapMarkerClass.static.CanSeeMarker(PRI, Marker)
          && !(PC.IsArtillerySpotter() && PRI.SquadIndex == Marker.SquadIndex)
          && PC.ArtillerySupportSquadIndex == Marker.SquadIndex
          && class<DHMapMarker_FireSupport>(Marker.MapMarkerClass) != none)
        {
            Marker.WorldLocation.Z = 0.0;
            Distance = VSize(Marker.WorldLocation - Marker.WorldLocation);

            if (MinimumDistance > Distance)
            {
                ClosestArtilleryRequest = i;
                MinimumDistance = Distance;
            }
        }
    }

    PC.ArtilleryHitInfo.ClosestArtilleryRequestIndex = ClosestArtilleryRequest;
    PC.ArtilleryHitInfo.bIsWithinRadius = (MinimumDistance < class'DHUnits'.static.MetersToUnreal(default.VisibilityRange));

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

static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.IsArtilleryOperator() && PC.ArtilleryHitInfo.bIsWithinRadius && !(PC.IsSL() && PC.GetSquadIndex() != Marker.SquadIndex);
}

defaultproperties
{
    IconMaterial=MaterialSequence'DH_InterfaceArt2_tex.Artillery.HitMarker'
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=6
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=PERSONAL
    LifetimeSeconds=15 // 30 seconds
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ARTILLERY_OPERATOR)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=NO_ONE)
    Permissions_CanPlace(0)=ARTILLERY_OPERATOR
    VisibilityRange=100
}
