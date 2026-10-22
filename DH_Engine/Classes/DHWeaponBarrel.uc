//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponBarrel extends Object
    abstract;

var     float       SteamTemperature;    // temp barrel begins to steam
var     float       CriticalTemperature; // temp barrel steams a lot and cone-fire error introduced
var     float       FailureTemperature;  // temp at which barrel fails and unusable
var     float       FiringHeatIncrement; // increase in barrel temp per shot fired
var     float       BarrelCoolingRate;   // rate at which barrel cools off (degrees per second)

simulated static function float GetFiringSoundPitch(float BarrelTemperature)
{
    return Class'UInterp'.static.MapRangeClamped(
        BarrelTemperature,
        default.CriticalTemperature,
        default.FailureTemperature,
        1.0,
        0.8125
    );
}

defaultproperties
{
    SteamTemperature=180.0
    CriticalTemperature=230.0
    FailureTemperature=315.0
    BarrelCoolingRate=1.75
    FiringHeatIncrement=1.3
}
