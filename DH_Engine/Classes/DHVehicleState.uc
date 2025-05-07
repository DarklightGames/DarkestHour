//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleState extends Object;

var int Health;
var array<DHVehicleWeaponState> WeaponStates;

static function DHVehicleState GetDefaultVehicleState(class<DHVehicle> VehicleClass)
{
    local int i;
    local DHVehicleState VehicleState;

    if (VehicleClass == none)
    {
        return none;
    }

    VehicleState = new class'DHVehicleState';
    VehicleState.Health = VehicleClass.default.Health;

    for (i = 0; i < VehicleClass.default.PassengerWeapons.Length; ++i)
    {
        VehicleState.WeaponStates[i] = new class'DHVehicleWeaponState';
    }

    return VehicleState;
}

function int GetTotalMainAmmoCharges()
{
    local int i, j, Total;
    local DHVehicleWeaponState WeaponState;

    for (i = 0; i < WeaponStates.Length; i++)
    {
        WeaponState = WeaponStates[i];

        if (WeaponState == none)
        {
            continue;
        }

        for (j = 0; j < arraycount(WeaponState.MainAmmoCharge); ++j)
        {
            Total += WeaponState.MainAmmoCharge[j];
        }
    }

    return Total;
}
