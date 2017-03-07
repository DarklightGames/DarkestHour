//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHATGunCannon extends DHVehicleCannon
    abstract;

// Emptied out as AT gun will always be penetrated by a shell & needs no penetration functionality
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector ProjectileDirection, float MaxArmorPenetration) { return true; }

defaultproperties
{
    bHasTurret=false
    RotationsPerSecond=0.025
    bLimitYaw=true
    ShakeRotMag=(Z=110.0)
    ShakeRotRate=(Z=1100.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetTime=2.0
}
