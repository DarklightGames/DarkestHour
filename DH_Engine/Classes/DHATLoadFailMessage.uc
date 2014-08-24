//=============================================================================
// DHATLoadFailMessage
//=============================================================================
// Message send to player when unable to reload an AT soldier. This occurs when
// the target player is not deployed and crouched/weapon rested.
//=============================================================================
// 2008 - PsYcH0_Ch!cKeN
//=============================================================================

class DHATLoadFailMessage extends ROCriticalMessage;

var localized string        CantLoad;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    return RelatedPRI_1.PlayerName $ default.CantLoad;
}

defaultproperties
{
     CantLoad=" must be deployed to be reloaded"
}
