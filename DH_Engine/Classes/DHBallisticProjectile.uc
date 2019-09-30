//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHBallisticProjectile extends ROBallisticProjectile
    abstract;

var DHVehicleWeapon VehicleWeapon;

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
    }
}

defaultproperties
{
}

