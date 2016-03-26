//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHATGunCannon extends DHVehicleCannon
    abstract;

// AT gun will always be penetrated by a shell
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
   return true;
}

defaultproperties
{
    bHasTurret=false
}
