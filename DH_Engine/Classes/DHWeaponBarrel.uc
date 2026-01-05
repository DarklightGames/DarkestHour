//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponBarrel extends Actor
    notplaceable;

// Non-volatile properties (make this an object type!)
var     float       LevelTempCentigrade; // the temperature of the level we're playing in (all temps here are in centigrade)
var     float       SteamTemperature;    // temp barrel begins to steam
var     float       CriticalTemperature; // temp barrel steams a lot and cone-fire error introduced
var     float       FailureTemperature;  // temp at which barrel fails and unusable
var     float       FiringHeatIncrement; // increase in barrel temp per shot fired
var     float       BarrelTimerRate;     // how often to call the timer to handle barrel cooling
var     float       BarrelCoolingRate;   // rate at which barrel cools off (degrees per second)

enum EBarrelCondition
{
    BC_Good,
    BC_Damaged, // If barrel passes CriticalTemperature, cone-fire error introduced.
    BC_Failed   // If barrel passes FailureTemperature, becomes unusable.
};

// Volatile properties
var     float               Temperature;
var     bool                bIsSteamActive;     // If barrel passes SteamTemperature, we'll start steaming the barrel.
var     EBarrelCondition    Condition;
var private bool            bIsCurrentBarrel;   // This is the weapon's current barrel, not a spare.

delegate OnTemperatureChanged(DHWeaponBarrel Barrel, float Temperature);
delegate OnIsSteamActiveChanged(DHWeaponBarrel Barrel, bool bIsSteamActive);
delegate OnConditionChanged(DHWeaponBarrel Barrel, EBarrelCondition NewCondition);

// Modified to set the LevelTempCentigrade & match barrel's starting temperature to that, & to start a repeating timer to handle barrel cooling & updating
simulated function PostBeginPlay()
{
    local int TempFahrenheit;

    super.PostBeginPlay();

    if (Role == ROLE_Authority && DarkestHourGame(Level.Game).LevelInfo != none)
    {
        TempFahrenheit = DarkestHourGame(Level.Game).LevelInfo.TempFahrenheit;
        LevelTempCentigrade = float(TempFahrenheit - 32) * 5.0 / 9.0;
        Temperature = LevelTempCentigrade;

        SetTimer(BarrelTimerRate, true);
    }
}

// Modified to make sure any steam effects are deactivated
simulated function Destroyed()
{
    if (bIsSteamActive)
    {
        OnIsSteamActiveChanged(self, false);
    }

    OnConditionChanged(self, BC_Good);
    OnTemperatureChanged(self, 0);

    super.Destroyed();
}

function bool IsCurrentBarrel()
{
    return bIsCurrentBarrel;
}

// Sets whether this barrel is the current one in the weapon & updates its status
function SetCurrentBarrel(bool bIsCurrent)
{
    bIsCurrentBarrel = bIsCurrent;

    if (bIsCurrentBarrel)
    {
        OnTemperatureChanged(self, Temperature);
        UpdateBarrelStatus(true);
    }
}

// Increases barrel temperature whenever the weapon fires
function WeaponFired()
{
    Temperature += FiringHeatIncrement;

    OnTemperatureChanged(self, Temperature);

    UpdateBarrelStatus();
}

// Periodically lowers the barrel temp, but no further than the level's ambient temp
function Timer()
{
    local float OldTemperature;

    if (Role == ROLE_Authority && Temperature != LevelTempCentigrade)
    {
        Temperature = FMax(LevelTempCentigrade, Temperature -= (BarrelCoolingRate * BarrelTimerRate));

        if (bIsCurrentBarrel && OldTemperature != Temperature)
        {
            OnTemperatureChanged(self, Temperature);
        }

        UpdateBarrelStatus();
    }
}

// Updates this barrel and the weapon's status
function UpdateBarrelStatus(optional bool bForce)
{
    local bool bOldIsSteamActive;

    if (Role != ROLE_Authority)
    {
        return;
    }

    bOldIsSteamActive = bIsSteamActive;
    bIsSteamActive = Temperature > SteamTemperature;

    if (bForce || bOldIsSteamActive != bIsSteamActive)
    {
        if (bIsCurrentBarrel)
        {
            OnIsSteamActiveChanged(self, bIsSteamActive);
        }
    }

    if (Condition < BC_Damaged && Temperature > CriticalTemperature)
    {
        Condition = BC_Damaged;

        if (bIsCurrentBarrel)
        {
            OnConditionChanged(self, Condition);
        }
    }
    else if (Condition < BC_Failed && Temperature > FailureTemperature)
    {
        Condition = BC_Failed;

        if (bIsCurrentBarrel)
        {
            OnConditionChanged(self, Condition);
        }
    }
}

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
    DrawType=DT_None
    bHidden=true
    bReplicateMovement=false
    RemoteRole=ROLE_None
    NetPriority=1.4
}
