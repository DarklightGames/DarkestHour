//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment_SpawnPoint_Admin extends DHMapIconAttachment_SpawnPoint
    notplaceable;

function EVisibleFor GetVisibility()
{
    // Admin spawn points are visible to everyone
    return VISIBLE_Enemy;
}

defaultproperties
{
    IconMaterial=Texture'DH_GUI_Tex.DeployMenu.SpawnPointDiffuse'
}
