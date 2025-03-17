//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHStationaryWeaponPickup extends DHWeaponPickup
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
    local DHStationaryWeapon StationaryWeapon;

    Copy = super.SpawnCopy(Other);

    StationaryWeapon = DHStationaryWeapon(Copy);

    if (StationaryWeapon != none)
    {
        StationaryWeapon.VehicleState = VehicleState;
    }

    return Copy;
}

// Modified to transfer the vehicle state to the dropped pickup.
function InitDroppedPickupFor(Inventory Inv)
{
    local DHStationaryWeapon StationaryWeapon;

    super.InitDroppedPickupFor(Inv);

    StationaryWeapon = DHStationaryWeapon(Inv);

    if (StationaryWeapon != none)
    {
        VehicleState = StationaryWeapon.VehicleState;
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
        MapIconAttachment.VehicleClass = StationaryWeapon.VehicleClass;

        if (Inv.Instigator != none)
        {
            MapIconAttachment.SetTeamIndex(Inv.Instigator.GetTeamNum());
        }

        MapIconAttachment.Setup();
    }
}

defaultproperties
{
    PlayerNearbyRadiusMeters=250
}
