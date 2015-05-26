//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleMessage extends ROVehicleMessage
    abstract;

var localized string CannotRide;
var localized string VehicleFull;
var localized string OpenHatch;
var localized string ExitCommandersHatch;
var localized string ExitDriverOrComHatch;
var localized string ExitCommandersOrMGHatch;
var localized string OverSpeed;
var localized string VehicleBurning;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    switch (Switch)
    {
        case 0:
            S = default.NotQualified;
            break;
        case 1:
            S = default.VehicleIsEnemy;
            break;
        case 2:
            S = default.CannotEnter;
            break;
        case 3:
            S = default.CannotRide;
            break;
        case 4:
            S = default.OpenHatch;
            break;
        case 5:
            S = default.ExitCommandersHatch;
            break;
        case 7:
            S = default.OverSpeed;
            break;
        case 8:
            S = default.VehicleFull;
            break;
        case 9:
            S = default.VehicleBurning;
            break;
        case 10:
            S = default.ExitDriverOrComHatch;
            break;
        case 11:
            S = default.ExitCommandersOrMGHatch;
            break;
        default:
            break;
    }

    if (PlayerController(OptionalObject) != none)
    {
        S = class'DarkestHourGame'.static.ParseLoadingHintNoColor(S, PlayerController(OptionalObject));
    }

    return S;
}

defaultproperties
{
    NotQualified="Not qualified to operate this vehicle"
    VehicleIsEnemy="Cannot use an enemy vehicle"
    CannotEnter="Cannot enter this vehicle"
    CannotRide="Cannot ride this vehicle"
    VehicleFull="All rider positions are occupied"
    OpenHatch="You must unbutton the hatch [%NEXTWEAPON%] to exit"
    ExitCommandersHatch="You must exit through commander's hatch"
    ExitDriverOrComHatch="Exit through driver's or commander's hatch"
    ExitCommandersOrMGHatch="Exit through commander's or MG hatch"
    OverSpeed="Slow down!"
    Vehicleburning="Vehicle is on fire!"
}
