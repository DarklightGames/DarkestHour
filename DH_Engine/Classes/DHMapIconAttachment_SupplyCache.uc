//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment_SupplyCache extends DHMapIconAttachment
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
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Supply_Cache'
    IconScale=0.03
}
