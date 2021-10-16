//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHBallisticProjectile extends ROBallisticProjectile
    abstract;

var DHVehicleWeapon VehicleWeapon;

// debugging stuff
var bool bIsCalibrating;
var float LifeStart;
var vector StartLocation;
var float DebugMils;

function SaveHitPosition(vector HitLocation, vector HitNormal, class<DHMapMarker_ArtilleryHit> MarkerClass)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local vector MapLocation;
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local int i;
    local float Distance, Threshold;
    local DHPlayerReplicationInfo PRI;
    local vector RequestLocation;

    PC = DHPlayer(InstigatorController);

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

    GRI.GetMapCoords(HitLocation, MapLocation.X, MapLocation.Y);
    PC.AddMarker(MarkerClass, MapLocation.X, MapLocation.Y, HitLocation);

    GRI.GetGlobalArtilleryMapMarkers(PC, MapMarkers);

    for (i = 0; i < MapMarkers.Length; ++i)
    {
        RequestLocation = MapMarkers[i].WorldLocation;
        RequestLocation.Z = 0.0;
        HitLocation.Z = 0.0;
        Distance = VSize(RequestLocation - HitLocation);
        Threshold = class'DHUnits'.static.MetersToUnreal(MarkerClass.default.VisibilityRange);

        if (Distance < Threshold)
        {
            // Tell the client to update their personal map marker
            PC.ClientAddPersonalMapMarker(MarkerClass, HitLocation);
            break;
        }
    }

    return;
}

simulated function BlowUp(vector HitLocation)
{
    local float Distance;

    if (Role == ROLE_Authority && VehicleWeapon != none && bIsCalibrating)
    {
        Distance = class'DHUnits'.static.UnrealToMeters(VSize(Location - StartLocation));

        Log("(Mils=" $ DebugMils $ ",Range=" $ int(Distance) $ ",TTI=" $ Round(Level.TimeSeconds - LifeStart) $ ")");
    }
}

defaultproperties
{
}
