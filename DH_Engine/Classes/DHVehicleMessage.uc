//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleMessage extends ROVehicleMessage
    abstract;

// Can't enter vehicle
var localized string AllRiderPositionsFull;
var localized string NoRiderPositions;
var localized string VehicleBurning;

// Can't exit vehicle
var localized string OpenHatchToExit;
var localized string ExitCommandersHatch;
var localized string ExitDriverOrComHatch;
var localized string ExitCommandersOrMGHatch;
var localized string CantFindExitPosition;

// Armored vehicle locking
var localized string VehicleNowLocked;
var localized string VehicleNowUnlocked;
var localized string AbandonedVehicleUnlocked;
var localized string CantEnterLockedVehicle;
var localized string MapDisabledVehicleLocking;
var localized string CantLockNonCrewVehicle;
var localized string OnlyTankCrewCanLockVehicle;
var localized string CanOnlyLockFromCrewPosition;
var localized string OtherCrewmanCanLockVehicle;

// Other
var localized string UnbuttonToReload;
var localized string VehicleScuttleInitiated;

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
            S = default.AllRiderPositionsFull;
            break;
        case 4:
            S = default.NoRiderPositions;
            break;
        case 5:
            S = default.VehicleBurning;
            break;
//      case 6, 7 & 8 LEFT SPARE
        case 9:
            S = default.OpenHatchToExit;
            break;
        case 10:
            S = default.ExitCommandersHatch;
            break;
        case 11:
            S = default.ExitDriverOrComHatch;
            break;
        case 12:
            S = default.ExitCommandersOrMGHatch;
            break;
        case 13:
            S = default.CantFindExitPosition;
            break;
//      case 14 & 15 LEFT SPARE
        case 16:
            S = default.UnbuttonToReload;
            break;
//      case 17, 18 & 19 LEFT SPARE
        case 20:
            S = default.VehicleNowLocked;
            break;
        case 21:
            S = default.VehicleNowUnlocked;
            break;
        case 22:
            S = default.CantEnterLockedVehicle;
            break;
        case 23:
            S = default.AbandonedVehicleUnlocked;
            break;
        case 24:
            S = default.MapDisabledVehicleLocking;
            break;
        case 25:
            S = default.CantLockNonCrewVehicle;
            break;
        case 26:
            S = default.OnlyTankCrewCanLockVehicle;
            break;
        case 27:
            S = default.CanOnlyLockFromCrewPosition;
            break;
        case 28:
            S = default.OtherCrewmanCanLockVehicle;
            break;
        case 29:
            S = default.VehicleScuttleInitiated;
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
    bIsUnique=true
    NotQualified="Not qualified to operate this vehicle"
    VehicleIsEnemy="Cannot use an enemy vehicle"
    CannotEnter="Vehicle is full"
    AllRiderPositionsFull="All rider positions are occupied"
    NoRiderPositions="Cannot ride on this vehicle"
    VehicleBurning="Vehicle is on fire!"
    OpenHatchToExit="You must unbutton the hatch [%NEXTWEAPON%] to exit"
    ExitCommandersHatch="You must exit through commander's hatch"
    ExitDriverOrComHatch="Exit through driver's or commander's hatch"
    ExitCommandersOrMGHatch="Exit through commander's or MG hatch"
    CantFindExitPosition="No exit location can be found"
    UnbuttonToReload="You must unbutton the hatch [%NEXTWEAPON%] to reload"
    VehicleNowLocked="Tank crew positions in this vehicle have now been locked"
    VehicleNowUnlocked="Tank crew positions in this vehicle have now been unlocked"
    AbandonedVehicleUnlocked="You left your locked vehicle for too long and it's now unlocked"
    CantEnterLockedVehicle="This vehicle has been locked by its crew"
    MapDisabledVehicleLocking="This map doesn't allow vehicles to be locked"
    CantLockNonCrewVehicle="Can't lock vehicle as it can be driven by non-tank crew roles"
    OnlyTankCrewCanLockVehicle="Only tank crew roles can lock or unlock vehicle"
    CanOnlyLockFromCrewPosition="Can only lock or unlock vehicle if you are in a tank crew position"
    OtherCrewmanCanLockVehicle="Only the most senior crew position can lock or unlock vehicle"
    VehicleScuttleInitiated="currently deprecated"
}
