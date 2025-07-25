//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerVehicleMessage extends ROVehicleMessage
    abstract;

var localized string MGBlockingHatch;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (Switch == 1)
    {
        return default.MGBlockingHatch;
    }

    return "";
}

defaultproperties
{
     MGBlockingHatch="MG is blocking the hatch - turn it sideways to open"
     bIsUnique=True
}
