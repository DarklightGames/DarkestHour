//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapIconAttachment_SpawnPoint extends DHMapIconAttachment
    notplaceable;

function EVisibleFor GetVisibility()
{
    return VISIBLE_None;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_Enemy;
}
