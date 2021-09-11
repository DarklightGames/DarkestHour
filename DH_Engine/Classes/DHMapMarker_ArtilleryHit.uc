//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit extends DHMapMarker
    abstract;

var int VisibilityRange;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker HitMarker)
{
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local DHGameReplicationInfo GRI;
    local int i;
    local float Distance, Threshold;
    local DHPlayerReplicationInfo PRI;
    local vector RequestLocation, HitLocation;

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

    GRI.GetGlobalArtilleryMapMarkers(PC, MapMarkers, PC.GetTeamNum());
    HitLocation = HitMarker.WorldLocation;
    HitLocation.Y = 0.0;

    for (i = 0; i < MapMarkers.Length; ++i)
    {
        if (PC.ArtillerySupportSquadIndex == MapMarkers[i].SquadIndex)
        {
            RequestLocation = MapMarkers[i].WorldLocation;
            RequestLocation.Y = 0.0;
            Distance = VSize(RequestLocation - HitLocation);
            Threshold = class'DHUnits'.static.MetersToUnreal(default.VisibilityRange);
            PC.ArtilleryHitInfo.bIsWithinRadius = (Distance < Threshold);
            PC.ArtilleryHitInfo.ExpiryTime = MapMarkers[i].ExpiryTime;
            return;
        }
    }

    PC.ArtilleryHitInfo.bIsWithinRadius = false;
    PC.ArtilleryHitInfo.ExpiryTime = 0;
}

static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.ArtilleryHitInfo.bIsWithinRadius;
}

defaultproperties
{
    IconMaterial=MaterialSequence'DH_InterfaceArt2_tex.Artillery.HitMarker'
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=6
    Type=MT_ArtilleryHit
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=PERSONAL
    LifetimeSeconds=15 // 30 seconds
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ARTILLERY_OPERATOR)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=NO_ONE)
    Permissions_CanPlace(0)=ARTILLERY_OPERATOR
    VisibilityRange=100
}
