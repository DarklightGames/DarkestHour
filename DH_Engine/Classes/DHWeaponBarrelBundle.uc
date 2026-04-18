//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// A management class for a weapon's barrels.
// We package this up into an actor because we don't want to have to write
// 3 different sets of management logic for infantry weapons, pickups, and
// vehicle weapons. We can just pass this bundle to the actor that owns the
// barrels.
//==============================================================================

class DHWeaponBarrelBundle extends Actor
    notplaceable;

var float LevelTemperatureCelcius; // The temperature of the level we're playing in (all temps here are in celcius)

var int BarrelIndex;
var array<DHWeaponBarrel> Barrels;

// TODO: we need some unified way to initialize the barrels from inventory, pickups and vehicle weapons.
// two possible scenarios:
// 1. brand new gun.
// 2. 

function PostBeginPlay()
{
    super.PostBeginPlay();
}

function int GetActiveBarrelIndex()
{
    return BarrelIndex;
}

private function DHWeaponBarrel GetActiveBarrel()
{
    return Barrels[BarrelIndex];
}

// Increases barrel active temperature when the weapon fires.
function WeaponFired()
{
    local DHWeaponBarrel Barrel;

    Barrel = GetActiveBarrel();

    if (Barrel == none)
    {
        return;
    }

    Barrel.Temperature += Barrel.FiringHeatIncrement;

    OnTemperatureChanged(self, Barrel.Temperature);

    UpdateBarrelStatuses();

    // TODO: a small optimization here would be to disable the timer once all the barrels cool down to ambient.
    // then re-enable the timer once the weapon is fired since there's otherwise nothing to do.
}

// Periodically lowers the barrel temp, but no further than the level's ambient temperature.
function Timer()
{
    local int i;
    local float OldTemperature;
    local DHWeaponBarrel Barrel;

    for (i = 0; i < Barrels.Length; ++i)
    {
        Barrel = Barrels[i];

        OldTemperature = Barrel.Temperature;

        if (Barrel.Temperature != LevelTemperatureCelcius)
        {
            Barrel.Temperature = FMax(LevelTemperatureCelcius, Barrel.Temperature -= (Barrel.BarrelCoolingRate * Barrel.BarrelTimerRate));

            if (i == BarrelIndex && OldTemperature != Barrel.Temperature)
            {
                OnTemperatureChanged(self, Barrel.Temperature);
            }
        }
    }
    
    UpdateBarrelStatuses();
}

// Returns the index of the next best barrel to switch to, sorting first by condition and then by temperature.
// Returns -1 if there are no barrels that can be changed to.
private function int GetNextBestBarrelIndex()
{
    local int i;
    local UComparator Comparator;
    local array<DHWeaponBarrel> SortedBarrels;

    // Copy the barrels to a new list to be sorted.
    SortedBarrels = Barrels;

    // Remove the current barrel and any failed barrels from the list to be sorted.
    SortedBarrels.Remove(BarrelIndex, 1);

    for (i = SortedBarrels.Length - 1; i >= 0; --i)
    {
        if (SortedBarrels[i].Condition == BC_Failed)
        {
            SortedBarrels.Remove(i, 1);
        }
    }

    if (SortedBarrels.Length == 0)
    {
        return -1;
    }

    // Sort in order of condition and temperature.
    Comparator = new Class'UComparator';
    Comparator.CompareFunction = Class'DHWeaponBarrel'.static.SortFunction;
    Class'USort'.static.Sort(SortedBarrels, Comparator);

    return Class'UArray'.static.IndexOf(Barrels, SortedBarrels[0]);
}

// Changes the barrel to the next best one available.
// Returns true when the barrel has changed.
function bool ChangeToNextBestBarrel()
{
    local int NextBarrelIndex;
    
    NextBarrelIndex = GetNextBestBarrelIndex();

    if (NextBarrelIndex == -1)
    {
        // Avoid out-of-bounds errors in case the function above returns -1 somehow.
        return false;
    }

    Level.Game.Broadcast(self, "Changing barrels from barrel" @ BarrelIndex @ "to barrel" @ NextBarrelIndex);

    BarrelIndex = NextBarrelIndex;

    OnTemperatureChanged(self, Barrels[BarrelIndex].Temperature);
    ForceUpdateBarrelStatus();

    return true;
}

// Resupply a failed barrel, so long as it not the active barrel.
function bool Resupply()
{
    local int i;

    for (i = 0; i < Barrels.Length; ++i)
    {
        if (i == BarrelIndex)
        {
            continue;
        }

        if (Barrels[i].Condition == BC_Failed)
        {
            Barrels[i].Condition = BC_Good;
            Barrels[i].Temperature = LevelTemperatureCelcius;
            return true;
        }
    }
}

// Modified to make sure any steam effects are deactivated.
function Destroyed()
{
    if (Barrels[BarrelIndex].bIsSteamActive)
    {
        OnIsSteamActiveChanged(self, false);
    }

    OnConditionChanged(self, BC_Good);
    OnTemperatureChanged(self, LevelTemperatureCelcius);

    super.Destroyed();
}

function ForceUpdateBarrelStatus()
{
    local DHWeaponBarrel Barrel;

    Barrel = GetActiveBarrel();

    if (Barrel == none)
    {
        return;
    }

    OnIsSteamActiveChanged(self, Barrel.bIsSteamActive);
    OnTemperatureChanged(self, Barrel.Temperature);
    OnConditionChanged(self, Barrel.Condition);
}

// Updates this barrel and the weapon's status
function UpdateBarrelStatuses()
{
    local int i;
    local bool bOldIsSteamActive;
    local DHWeaponBarrel Barrel;

    Barrel = GetActiveBarrel();

    if (Barrel == none)
    {
        return;
    }

    bOldIsSteamActive = Barrel.bIsSteamActive;
    Barrel.bIsSteamActive = Barrel.Temperature > Barrel.SteamTemperature;

    if (bOldIsSteamActive != Barrel.bIsSteamActive)
    {
        OnIsSteamActiveChanged(self, Barrel.bIsSteamActive);
    }

    if (Barrel.Condition < BC_Damaged && Barrel.Temperature > Barrel.CriticalTemperature)
    {
        Barrel.Condition = BC_Damaged;

        OnConditionChanged(self, Barrel.Condition);
    }
    else if (Barrel.Condition < BC_Failed && Barrel.Temperature > Barrel.FailureTemperature)
    {
        Barrel.Condition = BC_Failed;
        
        OnConditionChanged(self, Barrel.Condition);
    }
}

// Delegate functions for when the active barrel changes state.
// These functions are registered by the "owner" of the object to get state change events.
delegate OnConditionChanged(DHWeaponBarrel Barrel, DHWeaponBarrel.EBarrelCondition Condition);
delegate OnIsSteamActiveChanged(DHWeaponBarrel Barrel, bool bIsSteamActive);
delegate OnTemperatureChanged(DHWeaponBarrel Barrel, float TemperatureCelcius);

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=true
}
