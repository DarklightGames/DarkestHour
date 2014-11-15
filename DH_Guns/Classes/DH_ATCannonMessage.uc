//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ATCannonMessage extends ROVehicleMessage;

//==============================================================================
// Variables
//==============================================================================
var(Messages) localized string GunManned;
var(Messages) localized string CannotUse;
var(Messages) localized string NoExit;

//==============================================================================
// Functions
//==============================================================================
static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
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
             return default.CannotUse;
        default:
             return default.NoExit;
    }

}

defaultproperties
{
     GunManned="The Gun Is Fully Crewed"
     CannotUse="Cannot Use This Gun"
     NoExit="No Exit Location Can Not Be Found For This AT-Gun"
     VehicleIsEnemy="Cannot Use An Enemy AT-Gun"
}
