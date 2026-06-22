//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// A management class for a weapon's barrels.
//==============================================================================

class DHWeaponBarrelBundle extends Actor;

var private int CurrentBarrelIndex;
var array<DHWeaponBarrel> Barrels;

// Delegate functions for when the active barrel changes state.
delegate OnConditionChanged(DHWeaponBarrel Barrel, DHWeaponBarrel.EBarrelCondition Condition);
delegate OnIsSteamActiveChanged(DHWeaponBarrel Barrel, bool bIsSteamActive);
delegate OnTemperatureChanged(DHWeaponBarrel Barrel, float Temperature);

function Destroyed()
{
    super.Destroyed();

    DestroyBarrels();
}

private function DestroyBarrels()
{
    local int i;

    for (i = 0; i < Barrels.Length; ++i)
    {
        if (Barrels[i] != none)
        {
            Barrels[i].Destroy();
        }
    }
}

function int GetCurrentBarrelIndex()
{
    return CurrentBarrelIndex;
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
    SortedBarrels.Remove(CurrentBarrelIndex, 1);

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

function bool CanChangeBarrel()
{
    return GetNextBestBarrelIndex() != -1;
}

function PerformBarrelChange()
{
    local int NextBarrelIndex;
    
    NextBarrelIndex = GetNextBestBarrelIndex();

    if (NextBarrelIndex == -1)
    {
        // Avoid out-of-bounds errors in case the function above returns -1 somehow.
        return;
    }

    Level.Game.Broadcast(self, "Changed barrels from barrel" @ CurrentBarrelIndex @ "to barrel" @ NextBarrelIndex);

    Barrels[CurrentBarrelIndex].SetCurrentBarrel(false);
    Barrels[NextBarrelIndex].SetCurrentBarrel(true);

    CurrentBarrelIndex = NextBarrelIndex;
}

function DHWeaponBarrel GetCurrentBarrel()
{
    if (CurrentBarrelIndex < 0 || CurrentBarrelIndex >= Barrels.Length)
    {
        return none;
    }

    return Barrels[CurrentBarrelIndex];
}

function WeaponFired()
{
    local DHWeaponBarrel CurrentBarrel;

    if (CurrentBarrel != none)
    {
        CurrentBarrel.WeaponFired();
    }
}

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=true
}
