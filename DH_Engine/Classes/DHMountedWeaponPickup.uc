//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMountedWeaponPickup extends DHWeaponPickup
    abstract;

var DHVehicleState              VehicleState;
var array<DHWeaponBarrelBundle> WeaponBarrelBundles;
var DHMapIconAttachment_Vehicle MapIconAttachment;

simulated function Destroyed()
{
    super.Destroyed();

    if (MapIconAttachment != none)
    {
        MapIconAttachment.Destroy();
    }
}

// Modified to transfer vehicle state to the new inventory item.
function Inventory SpawnCopy(Pawn Other)
{
	local Inventory Copy;
    local DHMountedWeapon MW;
    local int i;

    Copy = super.SpawnCopy(Other);

    MW = DHMountedWeapon(Copy);

    if (MW != none)
    {
        MW.SetVehicleState(VehicleState);

        for (i = 0; i < WeaponBarrelBundles.Length; ++i)
        {
            MW.WeaponBarrelBundles[i] = WeaponBarrelBundles[i];
            MW.WeaponBarrelBundles[i].SetOwner(MW);
            MW.WeaponBarrelBundles[i].OnConditionChanged = none;
            MW.WeaponBarrelBundles[i].OnTemperatureChanged = none;
            MW.WeaponBarrelBundles[i].OnIsSteamActiveChanged = none;
            MW.WeaponBarrelBundles[i].ForceUpdateBarrelStatuses();

            WeaponBarrelBundles[i] = none;
        }
    }

    return Copy;
}

// Modified to transfer the vehicle state to the dropped pickup.
function InitDroppedPickupFor(Inventory Inv)
{
    local DHMountedWeapon MountedWeapon;
    local int i;

    super.InitDroppedPickupFor(Inv);

    MountedWeapon = DHMountedWeapon(Inv);

    if (MountedWeapon != none)
    {
        VehicleState = MountedWeapon.GetVehicleState();
    }

    if (MapIconAttachment != none)
    {
        MapIconAttachment.Destroy();
    }

    // Transfer barrel bundle.
    for (i = 0; i < MountedWeapon.WeaponBarrelBundles.Length; ++i)
    {
        WeaponBarrelBundles[i] = MountedWeapon.WeaponBarrelBundles[i]; 
        WeaponBarrelBundles[i].SetOwner(self);
        WeaponBarrelBundles[i].OnConditionChanged = none;
        WeaponBarrelBundles[i].OnTemperatureChanged = none;
        WeaponBarrelBundles[i].OnIsSteamActiveChanged = none;
        WeaponBarrelBundles[i].ForceUpdateBarrelStatuses();

        MountedWeapon.WeaponBarrelBundles[i] = none;
    }

    // Spawn the map icon attachment.
    MapIconAttachment = Spawn(class'DHMapIconAttachment_Vehicle', self);

    if (MapIconAttachment != none)
    {
        MapIconAttachment.SetBase(self);
        MapIconAttachment.VehicleClass = MountedWeapon.ConstructionClasses[0].default.VehicleClasses[0].VehicleClass;

        if (Inv.Instigator != none)
        {
            MapIconAttachment.SetTeamIndex(Inv.Instigator.GetTeamNum());
        }

        MapIconAttachment.Setup();
    }
}

defaultproperties
{
    bCanPickupWhileBusy=false
    PlayerNearbyRadiusMeters=250
}
