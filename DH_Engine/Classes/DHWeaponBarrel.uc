//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponBarrel extends Object
    abstract;

enum EBarrelCondition
{
    BC_Good,
    BC_Damaged, // If barrel passes CriticalTemperature, cone-fire error introduced.
    BC_Failed   // If barrel passes FailureTemperature, becomes unusable.
};

// Non-volatile properties (make this an object type!)
var     float       SteamTemperature;    // temp barrel begins to steam
var     float       CriticalTemperature; // temp barrel steams a lot and cone-fire error introduced
var     float       FailureTemperature;  // temp at which barrel fails and unusable
var     float       FiringHeatIncrement; // increase in barrel temp per shot fired
var     float       BarrelTimerRate;     // how often to call the timer to handle barrel cooling
var     float       BarrelCoolingRate;   // rate at which barrel cools off (degrees per second)

var float Temperature;
var bool bIsSteamActive;     // If barrel passes SteamTemperature, we'll start steaming the barrel.
var EBarrelCondition Condition;

static function float GetFiringSoundPitch(float BarrelTemperature)
{
    return Class'UInterp'.static.MapRangeClamped(
        BarrelTemperature,
        default.CriticalTemperature,
        default.FailureTemperature,
        1.0,
        0.8125
    );
}

// Sorts in order of least damaged to most damaged, then by temperature.
static function bool SortFunction(Object LHS, Object RHS)
{
    if (DHWeaponBarrel(LHS).Condition != DHWeaponBarrel(RHS).Condition)
    {
        return DHWeaponBarrel(LHS).Condition < DHWeaponBarrel(RHS).Condition;
    }

    return DHWeaponBarrel(LHS).Temperature < DHWeaponBarrel(RHS).Temperature;
}

defaultproperties
{
    SteamTemperature=180.0
    CriticalTemperature=230.0
    FailureTemperature=315.0
    BarrelCoolingRate=1.75
    FiringHeatIncrement=1.3
    BarrelTimerRate=3.0
}
