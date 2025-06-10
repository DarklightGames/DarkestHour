//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBallisticProjectile extends ROBallisticProjectile
    abstract;

var DHProjectileCalibrationInfo DebugCalibrationInfo;

function DHProjectileCalibrationInfo CreateCalibrationInfo(DHVehicleWeapon VehicleWeapon, Vector StartLocation, float DebugAngleValue, UUnits.EAngleUnit DebugAngleUnit)
{
    DebugCalibrationInfo = new Class'DHProjectileCalibrationInfo';
    DebugCalibrationInfo.VehicleWeapon = VehicleWeapon;
    DebugCalibrationInfo.StartLocation = StartLocation;
    DebugCalibrationInfo.DebugAngleValue = DebugAngleValue;
    DebugCalibrationInfo.DebugAngleUnit = DebugAngleUnit;
}

function SaveHitPosition(Vector HitLocation, Vector HitNormal, class<DHMapMarker_ArtilleryHit> MarkerClass)
{
    local DHPlayer PC, SpotterPC;
    local DHGameReplicationInfo GRI;
    local Vector MapLocation;
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local int i;
    local float Distance, Threshold;
    local Vector RequestLocation;
    local array<int> HitMarkerIndices;

    PC = DHPlayer(InstigatorController);
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (PC == none || GRI == none)
    {
        return;
    }

    // Gather a list of artillery markers within the distance threshold of the hit location.
    GRI.GetMapCoords(HitLocation, MapLocation.X, MapLocation.Y);
    GRI.GetGlobalArtilleryMapMarkers(PC, MapMarkers);

    for (i = 0; i < MapMarkers.Length; ++i)
    {
        RequestLocation = MapMarkers[i].WorldLocation;
        RequestLocation.Z = 0.0;
        HitLocation.Z = 0.0;
        Distance = VSize(RequestLocation - HitLocation);
        Threshold = Class'DHUnits'.static.MetersToUnreal(MarkerClass.default.VisibilityRange);

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

    // For each map marker in range, mark the hit on the map for the spotter as well.
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

simulated function BlowUp(Vector HitLocation)
{
    if (DebugCalibrationInfo != none)
    {
        DebugCalibrationInfo.LogHit(HitLocation);
    }
}
