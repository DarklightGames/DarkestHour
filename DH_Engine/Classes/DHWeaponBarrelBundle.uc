//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// A management class for a weapon's barrels.
// Allows for multiple active barrels, automatied barrel cooling.
//==============================================================================

class DHWeaponBarrelBundle extends Actor;

enum EBarrelCondition
{
    BC_Good,
    BC_Damaged, // If barrel passes CriticalTemperature, cone-fire error introduced.
    BC_Failed   // If barrel passes FailureTemperature, becomes unusable.
};

var class<DHWeaponBarrel> BarrelClass;

struct Barrel
{
    var float Temperature;
    var bool bIsSteamActive;
    var EBarrelCondition Condition;
};

// The temperature of the level we're playing in (all temps here are in centigrade).
var float LevelTempCentigrade;

var array<Barrel> Barrels;
// A list of barrel indices that are currently being used.
// In most cases, this will just be a single barrel, although
// some weapons have multiple barrels (e.g., quad .50 cal,
// CV33 hull MG).
var private array<int> ActiveBarrelIndices;

// Delegate functions for when the active barrel changes state.
delegate OnConditionChanged(int BarrelIndex, EBarrelCondition Condition);
delegate OnIsSteamActiveChanged(int BarrelIndex, bool bIsSteamActive);
delegate OnTemperatureChanged(int BarrelIndex, float Temperature);

const BARREL_TIMER_RATE = 3.0;

function int GetBarrelIndexFromActiveIndex(int ActiveBarrelIndex)
{
    return ActiveBarrelIndices[ActiveBarrelIndex];
}

// Modified to set the LevelTempCentigrade & match barrel's starting temperature to that, & to start a repeating timer to handle barrel cooling & updating
simulated function PostBeginPlay()
{
    local int TempFahrenheit;

    super.PostBeginPlay();

    if (Role == ROLE_Authority && DarkestHourGame(Level.Game).LevelInfo != none)
    {
        TempFahrenheit = DarkestHourGame(Level.Game).LevelInfo.TempFahrenheit;
        LevelTempCentigrade = class'DHUnits'.static.FahrenheitToCelcius(TempFahrenheit);

        SetTimer(BARREL_TIMER_RATE, true);
    }
}

// If ActiveBarrelCount is not provided, it will default to 1.
function Setup(class<DHWeaponBarrel> BarrelClass, int BarrelCount, optional int ActiveBarrelCount)
{
    local int i;

    self.BarrelClass = BarrelClass;

    Barrels.Length = BarrelCount;

    for (i = 0; i < Barrels.Length; ++i)
    {
        Barrels[i].Temperature = LevelTempCentigrade;
    }

    // Make sure we have at least one barrel active.
    ActiveBarrelCount = Max(1, ActiveBarrelCount);

    for (i = 0; i < ActiveBarrelCount; ++i)
    {
        ActiveBarrelIndices[i] = i;
    }
}

// Returns the index into the active barrel list, or -1 if it is not active.
function int GetActiveBarrelIndex(int BarrelIndex)
{
    local int i;

    for (i = 0; i < ActiveBarrelIndices.Length; ++i)
    {
        if (ActiveBarrelIndices[i] == BarrelIndex)
        {
            return i;
        }
    }

    return -1;
}

function bool IsBarrelActive(int BarrelIndex)
{
    return GetActiveBarrelIndex(BarrelIndex) != -1;
}

simulated function Destroyed()
{
    local int i, BarrelIndex;

    for (i = 0; i < ActiveBarrelIndices.Length; ++i)
    {
        BarrelIndex = ActiveBarrelIndices[i];

        if (Barrels[BarrelIndex].bIsSteamActive)
        {
            OnIsSteamActiveChanged(BarrelIndex, false);
        }

        OnConditionChanged(BarrelIndex, BC_Good);
        OnTemperatureChanged(BarrelIndex, 0);
    }

    super.Destroyed();
}

// Returns the index of the next best inactive barrel to switch to, sorting first by
// condition and then by temperature.
// Returns -1 if there are no barrels that can be changed to.
private function int GetNextBestBarrelIndex()
{
    local int i;
    local int NextBestBarrelIndex;

    NextBestBarrelIndex = -1;

    for (i = 0; i < Barrels.Length; ++i)
    {
        if (Barrels[i].Condition == BC_Failed)
        {
            // Barrel has failed, so we can't switch to it.
            continue;
        }

        if (IsBarrelActive(i))
        {
            // Barrel is active, so we can't switch to it.
            continue;
        }

        if (NextBestBarrelIndex == - 1)
        {
            NextBestBarrelIndex = i;
            continue;
        }
        
        if (Barrels[i].Condition <= Barrels[NextBestBarrelIndex].Condition &&
            Barrels[i].Temperature <= Barrels[NextBestBarrelIndex].Condition)
        {
            NextBestBarrelIndex = i;
        }
    }

    return NextBestBarrelIndex;
}

function bool CanChangeBarrel()
{
    return GetNextBestBarrelIndex() != -1;
}

function PerformBarrelChange(optional int ActiveBarrelIndex)
{
    local int NextBarrelIndex;
    
    NextBarrelIndex = GetNextBestBarrelIndex();

    if (NextBarrelIndex == -1)
    {
        // Avoid out-of-bounds errors in case the function above returns -1 somehow.
        return;
    }

    ActiveBarrelIndices[ActiveBarrelIndex] = NextBarrelIndex;

    ForceUpdateBarrelStatus(ActiveBarrelIndex);
}

// Increases barrel temperature whenever the weapon fires.
function WeaponFired(optional int ActiveBarrelIndex)
{
    local int BarrelIndex;
    
    BarrelIndex = ActiveBarrelIndices[ActiveBarrelIndex];

    if (BarrelIndex == -1)
    {
        return;
    }

    if (Barrels[BarrelIndex].Condition == BC_Failed)
    {
        // This barrel is broken, we can't fire it.
        return;
    }

    Barrels[BarrelIndex].Temperature += BarrelClass.default.FiringHeatIncrement;

    OnTemperatureChanged(ActiveBarrelIndex, Barrels[BarrelIndex].Temperature);

    UpdateBarrelStatus(BarrelIndex);
}

// Periodically lowers the barrel temp of all barrels, but no further than the level's ambient temperature.
function Timer()
{
    local float OldTemperature, ActiveBarrelIndex;
    local int i;

    for (i = 0; i < Barrels.Length; ++i)
    {
        OldTemperature = Barrels[i].Temperature;

        if (OldTemperature != Barrels[i].Temperature)
        {
            ActiveBarrelIndex = GetActiveBarrelIndex(i);

            if (ActiveBarrelIndex != -1)
            {
                OnTemperatureChanged(ActiveBarrelIndex, Barrels[i].Temperature);
            }
        }

        Barrels[i].Temperature = FMax(LevelTempCentigrade, Barrels[i].Temperature - (BarrelClass.default.BarrelCoolingRate * BARREL_TIMER_RATE));

        UpdateBarrelStatus(i);
    }
}

function ForceUpdateBarrelStatuses()
{
    local int i;

    for (i = 0; i < ActiveBarrelIndices.Length; ++i)
    {
        ForceUpdateBarrelStatus(i);
    }
}

function ForceUpdateBarrelStatus(int ActiveBarrelIndex)
{
    local int BarrelIndex;

    BarrelIndex = ActiveBarrelIndices[ActiveBarrelIndex];

    OnIsSteamActiveChanged(ActiveBarrelIndex, Barrels[BarrelIndex].bIsSteamActive);
    OnTemperatureChanged(ActiveBarrelIndex, Barrels[BarrelIndex].Temperature);
    OnConditionChanged(ActiveBarrelIndex, Barrels[BarrelIndex].Condition);
}

function bool AreAnyActiveBarrelsFailed()
{
    local int i;

    for (i = 0; i < ActiveBarrelIndices.Length; ++i)
    {
        if (Barrels[ActiveBarrelIndices[i]].Condition == BC_Failed)
        {
            return true;
        }
    }

    return false;
}

// Updates this barrel and the weapon's condition and steam active state.
function UpdateBarrelStatus(int BarrelIndex)
{
    local bool bOldIsSteamActive;
    local int ActiveBarrelIndex;

    ActiveBarrelIndex = GetActiveBarrelIndex(BarrelIndex);

    bOldIsSteamActive = Barrels[BarrelIndex].bIsSteamActive;
    Barrels[BarrelIndex].bIsSteamActive = Barrels[BarrelIndex].Temperature > BarrelClass.default.SteamTemperature;

    if (bOldIsSteamActive != Barrels[BarrelIndex].bIsSteamActive)
    {
        if (ActiveBarrelIndex != -1)
        {
            OnIsSteamActiveChanged(ActiveBarrelIndex, Barrels[BarrelIndex].bIsSteamActive);
        }
    }

    if (Barrels[BarrelIndex].Condition < BC_Damaged && Barrels[BarrelIndex].Temperature > BarrelClass.default.CriticalTemperature)
    {
        Barrels[BarrelIndex].Condition = BC_Damaged;

        if (ActiveBarrelIndex != -1)
        {
            OnConditionChanged(ActiveBarrelIndex, Barrels[BarrelIndex].Condition);
        }
    }
    else if (Barrels[BarrelIndex].Condition < BC_Failed && Barrels[BarrelIndex].Temperature > BarrelClass.default.FailureTemperature)
    {
        Barrels[BarrelIndex].Condition = BC_Failed;

        if (ActiveBarrelIndex != -1)
        {
            OnConditionChanged(ActiveBarrelIndex, Barrels[BarrelIndex].Condition);
        }
    }
}

function ResetBarrel(int BarrelIndex)
{
    if (BarrelIndex >= 0 && BarrelIndex < Barrels.Length)
    {
        Barrels[BarrelIndex].Condition = BC_Good;
        Barrels[BarrelIndex].bIsSteamActive = false;
        Barrels[BarrelIndex].Temperature = LevelTempCentigrade;
    }
}

// Replaces all inactive and failed barrels with good barrels.
// Returns the number of barrels replaced.
function int ReplaceInactiveFailedBarrels()
{
    // For all failed and inactive barrels, restore their condition to good and reset
    // their temperature to ambient.
    local int i, Count;

    for (i = 0; i < Barrels.Length; ++i)
    {
        if (Barrels[i].Condition == BC_Failed && !IsBarrelActive(i))
        {
            ResetBarrel(i);
            ++Count;
        }
    }

    return Count;
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    local int i;
    local string S;

    for (i = 0; i < Barrels.Length; ++i)
    {
        YPos += YL;
        Canvas.SetPos(4.0, YPos);
        S = "Barrel[" $ i $ "]" @ Barrels[i].Temperature $ "c" @ "(" $ GetEnum(enum'EBarrelCondition', Barrels[i].Condition) $ ")";
        
        if (IsBarrelActive(i))
        {
            S @= "<active>";
        }

        Canvas.DrawText(S);
    }
}

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=true
    DrawType=DT_None
}
