//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment_Vehicle_Supply extends DHMapIconAttachment_Vehicle
    notplaceable;

// VISIBILITY
// Normal -> friendly
// Danger Zone -> everyone
function UpdateVisibilityIndex()
{
    ChangeVisibilityInDangerZoneTo(NEUTRAL_TEAM_INDEX, GetTeamIndex());
}
