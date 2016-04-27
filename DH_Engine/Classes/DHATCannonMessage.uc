//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHATCannonMessage extends ROVehicleMessage
    abstract;

var localized string GunManned;
var localized string NoExit;

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
            return default.GunManned;
        case 4:
            return default.NoExit;
        default:
            return "";
    }
}

defaultproperties
{
    NotQualified="You are not qualified to operate this gun"
    VehicleIsEnemy="Cannot use an enemy gun"
    CannotEnter="Cannot use this gun"
    GunManned="The gun is fully crewed"
    NoExit="No exit location can be found"
}
