//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHATCannonMessage extends DHVehicleMessage
    abstract;

var localized string GunIsRotating;

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
        case 13:
            return default.CantFindExitPosition;
        case 14:
            return default.GunIsRotating;
        default:
            return "";
    }
}

defaultproperties
{
    NotQualified="Not qualified to operate this gun"
    VehicleIsEnemy="Cannot use an enemy gun"
    CannotEnter="The gun is already manned"
    GunIsRotating="The gun is being rotated"
}
