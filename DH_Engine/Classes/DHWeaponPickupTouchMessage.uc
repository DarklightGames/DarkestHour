//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponPickupTouchMessage extends DHControlsMessage;

static function string GetHeaderString(
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    return class'DHPlayer'.static.GetInventoryName(class<Inventory>(OptionalObject));
}

defaultproperties
{
    Controls(0)=(Keys=("USE"),Text="Pick Up")
}
