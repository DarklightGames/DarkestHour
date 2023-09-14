//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHATGunTouchMessage extends DHVehicleTouchMessage
    abstract;

var localized string RotateHintString;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local TreeMap_string_Object OM;
    local class<DHATGun> ATGunClass;
    local PlayerController PC;
    local Object O;

    OM = TreeMap_string_Object(OptionalObject);

    if (OM != none)
    {
        OM.Get("VehicleClass", O);
        ATGunClass = class<DHATGun>(O);

        OM.Get("Controller", O);
        PC = PlayerController(O);
    }

    if (ATGunClass != none)
    {
        S = Repl(default.TouchMessage, "{0}", ATGunClass.default.VehicleNameString);

        if (ATGunClass.default.bCanBeRotated)
        {
            S @= "(" $ default.RotateHintString $ ")";
        }
    }

    return class'DarkestHourGame'.static.ParseLoadingHintNoColor(S, PC);
}

defaultproperties
{
    RotateHintString="hold [%SHOWORDERMENU | ONRELEASE HIDEORDERMENU%] to rotate"
}
