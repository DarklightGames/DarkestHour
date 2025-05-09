//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponBarrel extends Actor
    notplaceable;

// Non-volatile properties
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
var     bool                bIsCurrentBarrel;   // This is the weapon's current barrel, not a spare.

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
        if (DHProjectileWeapon(Owner)!= none)
        {
            DHProjectileWeapon(Owner).SetBarrelSteamActive(false);
        }
        else if (DHWeaponPickup(Owner) != none)
        {
            DHWeaponPickup(Owner).SetBarrelSteamActive(false);
        }
        else if (DHVehicleMG(Owner) != none)
        {
            DHVehicleMG(Owner).SetBarrelTemperature(self, 0);
        }
    }

    super.Destroyed();
}

// Sets whether this barrel is the current one in the weapon & updates its status
function SetCurrentBarrel(bool bIsCurrent)
{
    bIsCurrentBarrel = bIsCurrent;

    if (bIsCurrentBarrel)
    {
        UpdateBarrelStatus();
    }
}

// Increases barrel temperature whenever the weapon fires
function WeaponFired()
{
    Temperature += FiringHeatIncrement;
    UpdateBarrelStatus();
}

// Periodically lowers the barrel temp, but no further than the level's ambient temp
function Timer()
{
    if (Role == ROLE_Authority && Temperature != LevelTempCentigrade)
    {
        Temperature = FMax(LevelTempCentigrade, Temperature -= (BarrelCoolingRate * BarrelTimerRate));
        UpdateBarrelStatus();
    }
}

// Updates this barrel and the weapon's status
function UpdateBarrelStatus()
{
    local DHProjectileWeapon    W;
    local DHWeaponPickup        PU;
    local DHVehicleMG           MG;

    if (Role != ROLE_Authority)
    {
        return;
    }

    bIsSteamActive = Temperature > SteamTemperature;

    if (Condition < BC_Damaged && Temperature > CriticalTemperature)
    {
        Condition = BC_Damaged;
    }
    else if (Condition < BC_Failed && Temperature > FailureTemperature)
    {
        Condition = BC_Failed;
    }

    if (!bIsCurrentBarrel)
    {
        return;
    }

    W = DHProjectileWeapon(Owner);
    PU = DHWeaponPickup(Owner);
    MG = DHVehicleMG(Owner);

    if (W != none)
    {
        W.SetBarrelSteamActive(bIsSteamActive);
        // TODO: update the DHProjectileWeapon to just have a Condition variable.
        W.SetBarrelDamaged(Condition == BC_Damaged);
        W.SetBarrelFailed(Condition == BC_Failed);
        W.SetBarrelTemperature(Temperature);
    }
    else if (PU != none)
    {
        PU.SetBarrelSteamActive(bIsSteamActive);
    }
    else if (MG != none)
    {
        MG.SetBarrelCondition(self, Condition);
        MG.SetBarrelTemperature(self, Temperature);
    }
}

simulated static function float GetFiringSoundPitch(float BarrelTemperature)
{
    return class'UInterp'.static.MapRangeClamped(
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
    BarrelTimerRate=3.0
    DrawType=DT_None
    bHidden=true
    bReplicateMovement=false
    RemoteRole=ROLE_None
    NetPriority=1.4
}
