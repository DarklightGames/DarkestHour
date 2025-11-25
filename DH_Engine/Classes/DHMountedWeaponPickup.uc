//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMountedWeaponPickup extends DHWeaponPickup
    abstract;

var DHVehicleState              VehicleState;
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
    local DHMountedWeapon MountedWeapon;

    Copy = super.SpawnCopy(Other);

    MountedWeapon = DHMountedWeapon(Copy);

    if (MountedWeapon != none)
    {
        MountedWeapon.SetVehicleState(VehicleState);
    }

    return Copy;
}

// Modified to transfer the vehicle state to the dropped pickup.
function InitDroppedPickupFor(Inventory Inv)
{
    local DHMountedWeapon MountedWeapon;

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

    // Spawn the map icon attachment.
    MapIconAttachment = Spawn(class'DHMapIconAttachment_Vehicle', self);

    if (MapIconAttachment != none)
    {
        MapIconAttachment.SetBase(self);
        MapIconAttachment.VehicleClass = MountedWeapon.ConstructionClass.default.VehicleClass;

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
