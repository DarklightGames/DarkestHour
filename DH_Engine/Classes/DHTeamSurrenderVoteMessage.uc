//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHTeamSurrenderVoteMessage extends GameMessage
    abstract;

var localized string VoteSucceededText;
var localized string VoteFailedText;
var localized string VoteSummaryText;

static function string GetString(
    optional int Data,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local string Output, VoteSummary;
    local int Switch, VotePercentage;

    class'UInteger'.static.ToShorts(Data, Switch, VotePercentage);

    switch (Switch)
    {
        case 0:
            Output = default.VoteSucceededText;
            break;
        case 1:
            Output = default.VoteFailedText;
            break;
        default:
            return "";
    }

    VoteSummary = Repl(default.VoteSummaryText, "{0}", VotePercentage);
    VoteSummary = Repl(VoteSummary, "{1}", int(class'DHVoteInfo_TeamSurrender'.default.VotePassedThresholdPercent * 100));

    return Repl(Output, "{0}", VoteSummary);
}

defaultproperties
{
    VoteSucceededText="The vote to surrender has succeeded ({0})"
    VoteFailedText="The vote to surrender has failed ({0})"
    VoteSummaryText="Yes: {0}%, Needed: {1}%"
}
