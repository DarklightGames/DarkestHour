//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    local DHPlayer PC, SpotterPC;
    local DHGameReplicationInfo GRI;
    local vector MapLocation;
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local int i;
    local float Distance, Threshold;
    local vector RequestLocation;
    local array<int> HitMarkerIndices;

    PC = DHPlayer(InstigatorController);
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (PC == none || GRI == none)
    {
        return;
    }

    GRI.GetMapCoords(HitLocation, MapLocation.X, MapLocation.Y);
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
            HitMarkerIndices[HitMarkerIndices.Length] = i;
        }
    }

    if (HitMarkerIndices.Length > 0 || Level.NetMode == NM_Standalone)
    {
        // Mark the hit on the map for the artillery gunner.
        PC.ClientAddPersonalMapMarker(MarkerClass, HitLocation);
    }

    // For each map marker we hit, mark the hit on the map for the spotter as well.
    for (i = 0; i < HitMarkerIndices.Length; ++i)
    {
        if (MapMarkers[HitMarkerIndices[i]].Author != none)
        {
            SpotterPC = DHPlayer(MapMarkers[HitMarkerIndices[i]].Author.Owner);

            if (SpotterPC != none)
            {
                SpotterPC.ClientAddPersonalMapMarker(MarkerClass, HitLocation);
            }
        }
    }
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
