//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionControlsMessage extends DHControlsMessage
    abstract;

static function string GetHeaderString(
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    local DHConstructionProxy CP;
    CP = DHConstructionProxy(OptionalObject);
    return CP.GetRuntimeData().MenuName;
}

static function bool ShouldShowControl(int Index, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHConstructionProxy CP;
    
    CP = DHConstructionProxy(OptionalObject);

    switch (Index)
    {
        case 4:
            return CP.GetRuntimeData().bHasVariants;
        case 5:
            return CP.GetRuntimeData().bHasSkins;
        default:
            return true;
    }
}

defaultproperties
{
    Controls(0)=(Keys=("FIRE"),Text="Confirm")
    Controls(1)=(Keys=("ROIRONSIGHTS"),Text="Cancel")
    Controls(2)=(Keys=("LEANLEFT","LEANRIGHT"),Text="Rotate")
    Controls(3)=(Keys=("ROMANUALRELOAD"),Text="Reset")
    Controls(4)=(Keys=("SWITCHFIREMODE"),Text="Change Variant")
    Controls(5)=(Keys=("ROMGOPERATION"),Text="Change Skin")
}
