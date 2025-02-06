//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHATGunRotateControlsMessage extends DHControlsMessage
    abstract;

static function string GetHeaderString(
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject)
{
    return Vehicle(OptionalObject).VehicleNameString;
}

defaultproperties
{
    Controls(0)=(Keys=("FIRE","ROIRONSIGHTS"),Text="Finish rotating")
    Controls(1)=(Keys=("LEANLEFT","LEANRIGHT"),Text="Rotate")
}
