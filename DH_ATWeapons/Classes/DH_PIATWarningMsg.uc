//-----------------------------------------------------------
//DH_BazookaWarningMsg
//-----------------------------------------------------------
class DH_PIATWarningMsg extends ROCriticalMessage;

var(Messages) localized string NoHipFire;
var(Messages) localized string ReloadWarning;
var(Messages) localized string NeedSupport;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )

{
    switch(Switch)
    {
            case 0:
                return default.NoHipFire;
            case 1:
                return default.NeedSupport;
            case 2:
                return default.ReloadWarning;
            default:
                return default.NeedSupport;
    }
}

defaultproperties
{
     NoHipFire="You cannot fire the PIAT from the hip"
     ReloadWarning="You need to be prone or weapon rested to reload the PIAT"
     NeedSupport="You need to be prone or weapon rested to fire the PIAT"
}
