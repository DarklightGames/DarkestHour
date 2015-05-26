//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleTouchMessage extends ROTouchMessagePlus
    abstract;

var const string TouchMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local ObjectMap OM;
    local class<Vehicle> VehicleClass;
    local PlayerController PC;

    OM = ObjectMap(OptionalObject);

    if (OM != none)
    {
        VehicleClass = class<Vehicle>(OM.Get("VehicleClass"));
        PC = PlayerController(OM.Get("Controller"));
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
    TouchMessage="Press [%USE%] to enter {0}";
}
