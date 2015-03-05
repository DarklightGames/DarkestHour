//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_VehicleMessage extends ROVehicleMessage;

var(Messages) localized string CannotRide;
var(Messages) localized string VehicleFull;
var(Messages) localized string OpenHatch;
var(Messages) localized string ExitCommandersHatch;
var(Messages) localized string ExitDriverOrComHatch;
var(Messages) localized string ExitCommandersOrMGHatch;
var(Messages) localized string OverSpeed;
var(Messages) localized string VehicleBurning;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.NotQualified;
        case 1:
            return default.VehicleIsEnemy;
        case 2:
            return default.CannotEnter;
        case 3:
            return default.CannotRide;
        case 4:
            return default.OpenHatch;
        case 5:
            return default.ExitCommandersHatch;
        case 7:
            return default.OverSpeed;
        case 8:
            return default.VehicleFull;
        case 9:
            return default.VehicleBurning;
        case 10:
            return default.ExitDriverOrComHatch;
        case 11:
            return default.ExitCommandersOrMGHatch;
        default:
            return "";
    }
}

defaultproperties
{
    NotQualified="Not qualified to operate this vehicle"
    VehicleIsEnemy="Cannot use an enemy vehicle"
    CannotEnter="Cannot enter this vehicle"
    CannotRide="Cannot ride this vehicle"
    VehicleFull="All rider positions are occupied"
    OpenHatch="You must unbutton the hatch to exit"
    ExitCommandersHatch="You must exit through commander's hatch"
    ExitDriverOrComHatch="Exit through driver's or commander's hatch"
    ExitCommandersOrMGHatch="Exit through commander's or MG hatch"
    OverSpeed="Slow down!"
    Vehicleburning="Vehicle is on fire!"
}
