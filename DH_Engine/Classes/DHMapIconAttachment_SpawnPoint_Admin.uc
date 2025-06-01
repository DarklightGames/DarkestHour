//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
