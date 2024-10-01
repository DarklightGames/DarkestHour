//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment_Mortar extends DHMapIconAttachment
    notplaceable;

function EVisibleFor GetVisibility()
{
    return VISIBLE_Team;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_Enemy;
}

defaultproperties
{
    IconMaterial=TexRotator'DH_InterfaceArt2_tex.Icons.mortar_topdown_rot'
}
