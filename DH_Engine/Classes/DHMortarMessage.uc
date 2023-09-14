//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarMessage extends ROCriticalMessage
    abstract;

var localized string MustCrouch;
var localized string MustBeStill;
var localized string CannotLean;
var localized string BadSurface;
var localized string NotEnoughRoom;
var localized string CannotDeploy;
var localized string InWater;
var localized string NotQualified;
var localized string InUse;
var localized string EnemyMortar;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 1:
            return default.MustCrouch;
        case 3:
            return default.MustBeStill;
        case 4:
            return default.BadSurface;
        case 5:
            return default.NotEnoughRoom;
        case 6:
            return default.CannotLean;
        case 7:
            return default.InWater;
        case 8:
            return default.NotQualified;
        case 9:
            return default.InUse;
        case 10:
            return default.EnemyMortar;
        case 11:
            return default.CannotDeploy;
        default:
            return default.CannotDeploy;
    }
}

defaultproperties
{
    MustCrouch="You must be crouched to deploy your mortar"
    MustBeStill="You cannot deploy your mortar while moving"
    CannotLean="You cannot deploy your mortar while leaning"
    BadSurface="You cannot deploy your mortar on this surface"
    NotEnoughRoom="You do not have enough room to deploy your mortar here"
    CannotDeploy="You cannot deploy your mortar here"
    InWater="You cannot deploy your mortar in water"
    NotQualified="You are not qualified to operate this mortar"
    InUse="You cannot operate this mortar as it is currently in use"
    EnemyMortar="You cannot operate enemy mortars"
}
