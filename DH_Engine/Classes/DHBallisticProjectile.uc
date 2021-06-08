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

    PC = DHPlayer(InstigatorController);

    if (PC != none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
        GRI.GetMapCoords(HitLocation, MapLocation.X, MapLocation.Y);
        PC.AddMarker(MarkerClass, MapLocation.X, MapLocation.Y, HitLocation);
    }
}

simulated function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        SetHitLocation(HitLocation);
    }
}

// New function to set hit location in team's artillery targets so it's marked on the map for mortar crew
function SetHitLocation(vector HitLocation)
{
    local float Distance;

    if (VehicleWeapon != none)
    {
        VehicleWeapon.ArtilleryHitLocation.HitLocation = HitLocation;
        VehicleWeapon.ArtilleryHitLocation.ElapsedTime = Level.Game.GameReplicationInfo.ElapsedTime;

        if (bIsCalibrating)
        {
            Distance = class'DHUnits'.static.UnrealToMeters(VSize(Location - StartLocation));

            Log("(Mils=" $ DebugMils $ ",Range=" $ int(Distance) $ ",TTI=" $ Round(Level.TimeSeconds - LifeStart) $ ")");
        }
    }
}

defaultproperties
{
}
