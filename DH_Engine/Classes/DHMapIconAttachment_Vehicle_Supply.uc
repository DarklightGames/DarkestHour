//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment_Vehicle_Supply extends DHMapIconAttachment_Vehicle
    notplaceable;

function EVisibleFor GetVisibility()
{
    return VISIBLE_Team;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_All;
}

defaultproperties
{
    IconMaterial=TexRotator'DH_GUI_Tex.GUI.supply_point_rot'
}
