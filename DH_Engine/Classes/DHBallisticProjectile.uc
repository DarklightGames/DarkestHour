//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHBallisticProjectile extends ROBallisticProjectile
    abstract;

var DHVehicleWeapon VehicleWeapon;

// debugging stuff
var DHDebugFireCalibration DebugFireCalibration;
var int                    DebugIndex;

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
        MarkerClass.static.AddMarker(PC, MapLocation.X, MapLocation.Y);
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
    if (VehicleWeapon != none)
    {
        VehicleWeapon.ArtilleryHitLocation.HitLocation = HitLocation;
        VehicleWeapon.ArtilleryHitLocation.ElapsedTime = Level.Game.GameReplicationInfo.ElapsedTime;

        if (DebugFireCalibration != none)
        {
            DebugFireCalibration.RecordDataPoint(self);
        }
    }
}

defaultproperties
{
}
