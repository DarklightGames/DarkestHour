//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
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

    S = class'DarkestHourGame'.static.ParseLoadingHintNoColor(default.TouchMessage, PC);

    if (ATGunClass != none)
    {
        S = Repl(S, "{0}", ATGunClass.default.VehicleNameString);

        if (ATGunClass.default.bCanBeRotated)
        {
            S @= "(" $ default.RotateHintString $ ")";
        }
    }

    return S;
}

defaultproperties
{
    RotateHintString="hold [%SHOWORDERMENU | ONRELEASE HIDEORDERMENU%] to rotate"
}

