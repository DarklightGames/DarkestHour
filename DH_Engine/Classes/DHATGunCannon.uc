//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHATGunCannon extends DHVehicleCannon
    abstract;

// Emptied out as AT gun will always be penetrated by a shell & needs no penetration functionality
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector ProjectileDirection, float MaxArmorPenetration) { return true; }

// Functions emptied out as irrelevant to an AT gun, which never has alt fire (i.e. coaxial MG) or a smoke launcher:
simulated function AttemptFireSmokeLauncher();
function ServerFireSmokeLauncher();
simulated function AdjustSmokeLauncher(bool bIncrease);
function ServerAdjustSmokeLauncher(bool bIncrease);
simulated function AttemptAltReload();
simulated function AttemptSmokeLauncherReload();
simulated function StartAltReload(optional bool bResumingPausedReload);
simulated function StartSmokeLauncherReload(optional bool bResumingPausedReload);
simulated function PauseAltReload();
simulated function PauseSmokeLauncherReload();

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
