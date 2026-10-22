//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMountedWeaponControlsMessage extends DHControlsMessage
    abstract;

static function bool ShouldShowControl(int Index, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHMountedWeapon MW;

    MW = DHMountedWeapon(OptionalObject);

    if (MW == none)
    {
        return false;
    }

    switch (Index)
    {
        case 1:
            return MW.ConstructionClasses.Length > 1;
        default:
            return true;
    }
}

defaultproperties
{
    Controls(0)=(Keys=("DEPLOY"),Text="Deploy")
    Controls(1)=(Keys=("SWITCHFIREMODE"),Text="Change Variant")
}
