//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCounterBatteryManager extends Actor
    dependson(DHVehicleWeapon)
    notplaceable;

const SMALL_DEVIATION = 100;
const MEDIUM_DEVIATION = 75;
const LARGE_DEVIATION = 50;

// The index of the team who will be notified of the artillery reports with markers.
var int TeamIndex;

function Reset()
{
    // TODO: when we have something worth resetting here, set it up.

    super.Reset();
}

// Gets the deviation range in meters based on the counter-battery report type.
static function float GetDeviationMax(Class<DHVehicleWeapon> VehicleClass)
{
    if (VehicleClass == none)
    {
        return MEDIUM_DEVIATION;    // Fallback value, mainly for debugging.
    }

    switch (VehicleClass.default.CounterBatteryReport)
    {
        case CBR_Small:
            return SMALL_DEVIATION;
        case CBR_Medium:
            return MEDIUM_DEVIATION;
        case CBR_Large:
            return LARGE_DEVIATION;
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
    
    // Get a random range deviation using a uniform distribution so that it's spread evenly across the cicle.
    Deviation = GetDeviationMax(VehicleWeaponClass) * Sqrt(FRand());
    Deviation = class'DHUnits'.static.MetersToUnreal(Deviation);

    // TODO: add some sort of context-dependent modifier to the deviation
    // (e.g., number and distribution of listening posts)

    // Pick a random direction for the deviation.
    Theta = FRand() * Pi * 2;

    MarkerLocation = WorldLocation;
    MarkerLocation.X += Cos(Theta) * Deviation;
    MarkerLocation.Y += Sin(Theta) * Deviation;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        // TODO:
        if (Level.NetMode != NM_Standalone && PC.GetTeamNum() != TeamIndex)
        {
            continue;
        }

        PC = DHPlayer(C);

        if (PC != none)
        {
            PC.ClientAddPersonalMapMarker(class'DHMapMarker_CounterBattery', MarkerLocation);
        }
    }
}

defaultproperties
{
    RemoteRole=ROLE_None
}
