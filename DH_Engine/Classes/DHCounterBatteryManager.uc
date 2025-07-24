//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCounterBatteryManager extends Actor
    dependson(DHVehicleWeapon)
    notplaceable;

// The index of the team who will be notified of the artillery reports with markers.
var int TeamIndex;

// Gets the deviation range in meters based on the counter-battery report type.
static function float GetDeviationMax(Class<DHVehicleWeapon> VehicleClass)
{
    if (VehicleClass == none)
    {
        return 75.0;    // Fallback value, mainly for debugging.
    }

    switch (VehicleClass.default.CounterBatteryReport)
    {
        case CBR_Small:
            return 100.0;
        case CBR_Medium:
            return 75.0;
        case CBR_Large:
            return 50.0;
        default:
            return 0.0;
    }
}

function OnArtilleryFired(Class<DHVehicleWeapon> VehicleWeaponClass, Vector WorldLocation)
{
    local Controller C;
    local DHPlayer PC;
    local Vector MarkerLocation;
    local float Deviation, Theta;
    
    // Get a random range deviation using a uniform distribution so that it's spread evenly.
    Deviation = GetDeviationMax(VehicleWeaponClass) * Sqrt(FRand());
    Deviation = class'DHUnits'.static.MetersToUnreal(Deviation);

    // TODO: in future, shrink the deviation based on the proximity of listening location.

    // Pick a random direction for the deviation.
    Theta = FRand() * Pi * 2;

    MarkerLocation = WorldLocation;
    MarkerLocation.X += Cos(Theta) * Deviation;
    MarkerLocation.Y += Sin(Theta) * Deviation;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        PC = DHPlayer(C);

        if (PC == none)
        {
            continue;
        }

        // TODO:
        if (Level.NetMode != NM_Standalone && PC.GetTeamNum() != TeamIndex)
        {
            continue;
        }

        PC.ClientAddPersonalMapMarker(class'DHMapMarker_CounterBattery', MarkerLocation);
    }
}

defaultproperties
{
    RemoteRole=ROLE_None
}
