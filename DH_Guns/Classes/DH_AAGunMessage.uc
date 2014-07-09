class DH_AAGunMessage extends ROVehicleMessage;

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

//==============================================================================
// defaultproperties
//==============================================================================

defaultproperties
{
     GunManned="The Anti-Aircraft Gun Is Fully Crewed"
     CannotUse="Cannot Use This Anti-Aircraft Gun"
     NoExit="No Exit Location Can Be Found For This Anti-Aicraft Gun"
     NotQualified="You Are Not Qualified To Operate Anti-Aircraft Guns"
     VehicleIsEnemy="Cannot Use An Enemy Anti-Aicraft Gun"
}
