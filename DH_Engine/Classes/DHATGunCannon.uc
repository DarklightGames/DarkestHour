//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHATGunCannon extends DHVehicleCannon
    abstract;

// Functions emptied out as AT gun will always be penetrated by a shell & needs no penetration functionality:
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber) { return true; }
simulated function bool CheckPenetration(DHAntiVehicleProjectile P, float ArmorFactor, float CompoundAngle, float PenetrationNumber) { return true; }
simulated function bool CheckIfShatters(DHAntiVehicleProjectile P, float PenetrationRatio, optional float OverMatchFactor) { return false; }
simulated function float GetArmorSlopeMultiplier(DHAntiVehicleProjectile P, float CompoundAngleDegrees, optional float OverMatchFactor) { return 1.0; }
simulated function float ArmorSlopeTable(DHAntiVehicleProjectile P, float CompoundAngleDegrees, float OverMatchFactor) { return 1.0; }

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
