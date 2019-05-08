//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment_ATGun extends DHMapIconAttachment
    abstract
    notplaceable;

// VISIBILITY
// Normal -> friendly
// Danger Zone -> enemy
function UpdateVisibilityIndex()
{
    ChangeVisibilityInDangerZoneTo(GetOppositeTeamIndex(), GetTeamIndex());
}
