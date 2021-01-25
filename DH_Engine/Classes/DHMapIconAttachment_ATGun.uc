//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapIconAttachment_ATGun extends DHMapIconAttachment
    abstract
    notplaceable;

function EVisibleFor GetVisibility()
{
    return VISIBLE_Team;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_Enemy;
}
