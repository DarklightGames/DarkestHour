//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment_SupplyCache extends DHMapIconAttachment
    notplaceable;

// VISIBILITY
// Normal -> friendly
// Danger Zone -> everyone
function UpdateVisibilityIndex()
{
    ChangeVisibilityInDangerZoneTo(NEUTRAL_TEAM_INDEX, GetTeamIndex());
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Supply_Cache'
    IconScale=0.03
}
