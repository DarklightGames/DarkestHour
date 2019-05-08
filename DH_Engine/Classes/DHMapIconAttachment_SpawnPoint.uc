//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment_SpawnPoint extends DHMapIconAttachment
    notplaceable;

// VISIBILITY
// Normal -> nobody
// Danger Zone -> enemy
function UpdateVisibilityIndex()
{
    ChangeVisibilityInDangerZoneTo(GetOppositeTeamIndex(), 255);
}
