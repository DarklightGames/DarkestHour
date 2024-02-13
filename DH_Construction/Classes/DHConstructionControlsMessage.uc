//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    return CP.ConstructionClass.static.GetMenuName(CP.GetContext());
}

defaultproperties
{
    Controls(0)=(Keys=("FIRE"),Text="Confirm")
    Controls(1)=(Keys=("ROIRONSIGHTS"),Text="Cancel")
    Controls(2)=(Keys=("LEANLEFT","LEANRIGHT"),Text="Rotate")
    Controls(3)=(Keys=("ROMANUALRELOAD"),Text="Reset Rotation")
}
