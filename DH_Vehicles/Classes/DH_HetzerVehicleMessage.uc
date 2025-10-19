//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerVehicleMessage extends ROVehicleMessage
    abstract;

var localized string MGBlockingHatch;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.MGBlockingHatch;
}

defaultproperties
{
     MGBlockingHatch="Hatch blocked! Turn MG to 8 o'clock to unblock it."
     bIsUnique=True
     bIsConsoleMessage=false
}
