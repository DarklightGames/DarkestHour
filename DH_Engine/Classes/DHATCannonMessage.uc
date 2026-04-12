//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHATCannonMessage extends DHVehicleMessage
    abstract;

var localized string GunIsRotating;
var localized string WeaponIsDetached;

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
        case 15:
            return default.WeaponIsDetached;
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
    WeaponIsDetached="The weapon is detached"
}
