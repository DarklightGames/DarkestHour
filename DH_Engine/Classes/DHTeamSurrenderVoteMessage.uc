//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHTeamSurrenderVoteMessage extends GameMessage
    abstract;

var localized string VoteFailed;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    switch (Switch)
    {
        case 0:
            return default.VoteFailed;
        default:
            return "";
    }
}

defaultproperties
{
    VoteFailed="Your team voted to continue fighting."
}
