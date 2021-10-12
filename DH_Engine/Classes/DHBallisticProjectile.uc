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

simulated function SaveHitPostion(vector HitLocation, vector HitNormal, class<DHMapMarker_ArtilleryHit> MarkerClass)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local vector MapLocation;
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local int i;
    local float Distance, Threshold;
    local DHPlayerReplicationInfo PRI;
    local vector RequestLocation;
    local bool bIsWithinRadius;

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

    if (PC.ArtillerySupportSquadIndex != 255)
    {
        GRI.GetGlobalArtilleryMapMarkers(PC, MapMarkers);

        for (i = 0; i < MapMarkers.Length; ++i)
        {
            if (PC.ArtillerySupportSquadIndex == MapMarkers[i].SquadIndex)
            {
                RequestLocation = MapMarkers[i].WorldLocation;
                RequestLocation.Y = 0.0;
                HitLocation.Y = 0.0;
                Distance = VSize(RequestLocation - HitLocation);
                Threshold = class'DHUnits'.static.MetersToUnreal(MarkerClass.default.VisibilityRange);
                bIsWithinRadius = Distance < Threshold;

                if (bIsWithinRadius)
                {
                    PC.ArtilleryHitInfo.bIsWithinRadius = true;
                    PC.ArtilleryHitInfo.ExpiryTime = MapMarkers[i].ExpiryTime;
                }
                else
                {
                    PC.ArtilleryHitInfo.bIsWithinRadius = false;
                    PC.ArtilleryHitInfo.ExpiryTime = 0;
                }

                return;
            }
        }
    }

    PC.ArtilleryHitInfo.bIsWithinRadius = false;
    PC.ArtilleryHitInfo.ExpiryTime = 0;
    return;
}

simulated function BlowUp(vector HitLocation)
{
    local float Distance;

    if (Role == ROLE_Authority)
    {
        if (VehicleWeapon != none)
        {

            if (bIsCalibrating)
            {
                Distance = class'DHUnits'.static.UnrealToMeters(VSize(Location - StartLocation));

                Log("(Mils=" $ DebugMils $ ",Range=" $ int(Distance) $ ",TTI=" $ Round(Level.TimeSeconds - LifeStart) $ ")");
            }
        }
    }
}

defaultproperties
{
}
