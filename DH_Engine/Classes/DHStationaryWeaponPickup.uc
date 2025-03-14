//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHStationaryWeaponPickup extends DHWeaponPickup
    abstract;

var DHVehicleState VehicleState;

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
}

defaultproperties
{
    PlayerNearbyRadiusMeters=250
}
