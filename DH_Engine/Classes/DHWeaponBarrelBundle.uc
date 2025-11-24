//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// A management class for a weapon's barrels.
//==============================================================================

class DHWeaponBarrelBundle extends Actor;

var int BarrelIndex;    // The current active barrel.
var array<DHWeaponBarrel> Barrels;

// Delegate functions for when the active barrel changes state.
delegate OnConditionChanged(DHWeaponBarrel Barrel, DHWeaponBarrel.EBarrelCondition Condition);
delegate OnIsSteamActiveChanged(DHWeaponBarrel Barrel, bool bIsSteamActive);
delegate OnTemperatureChanged(DHWeaponBarrel Barrel, float Temperature);

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=true
}
