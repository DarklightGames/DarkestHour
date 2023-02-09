//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleTouchMessage extends ROTouchMessagePlus
    abstract;

var localized string TouchMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local TreeMap_string_Object OM;
    local class<Vehicle> VehicleClass;
    local PlayerController PC;
    local Object O;

    OM = TreeMap_string_Object(OptionalObject);

    if (OM != none)
    {
        OM.Get("VehicleClass", O);
        VehicleClass = class<Vehicle>(O);

        OM.Get("Controller", O);
        PC = PlayerController(O);
    }

    S = class'DarkestHourGame'.static.ParseLoadingHintNoColor(default.TouchMessage, PC);

    if (VehicleClass != none)
    {
        S = Repl(S, "{0}", VehicleClass.default.VehicleNameString);
    }

    return S;
}

defaultproperties
{
    TouchMessage="Press [%USE%] to enter {0}"
}
