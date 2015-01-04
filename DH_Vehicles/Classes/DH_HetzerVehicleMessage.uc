//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HetzerVehicleMessage extends ROVehicleMessage;

var(Messages) localized string CannotExit;
var(Messages) localized string UnbuttonToReloadMG;
var(Messages) localized string CannotFireMGUnbuttoned;
var(Messages) localized string MGBlockingHatch;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.CannotExit;
        case 1:
            return default.UnbuttonToReloadMG;
        case 2:
            return default.CannotFireMGUnbuttoned;
        case 3:
            return default.MGBlockingHatch;
    }
}

defaultproperties
{
    CannotExit="You must exit through the commander's or loader's hatch"
    UnbuttonToReloadMG="You must open the hatch to reload the MG"
    CannotFireMGUnbuttoned="You cannot fire the MG while unbuttoned"
    MGBlockingHatch="The MG is blocking the hatch - turn it sideways to open"
    bFadeMessage=false
}
