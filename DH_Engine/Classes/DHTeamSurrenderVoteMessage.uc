//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHTeamSurrenderVoteMessage extends GameMessage
    abstract;

var localized string VoteSucceededText;
var localized string VoteFailedText;
var localized string VoteSummaryText;
var localized string VoteNominatedText;
var localized string VoteNominationsRemainingText;

static function string GetString(
    optional int Data,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local byte Switch, Bytes[2];
    local string Output, VoteSummary;

    Class'UInteger'.static.ToBytes(Data, Switch, Bytes[0], Bytes[1]);

    switch (Switch)
    {
        case 0:
        case 1:
            // The vote has concluded

            if (!bool(Switch))
            {
                Output = default.VoteSucceededText;
            }
            else
            {
                Output = default.VoteFailedText;
            }

            VoteSummary = Repl(Repl(default.VoteSummaryText, "{0}", Bytes[0]), "{1}", Bytes[1]);

            return Repl(Output, "{0}", VoteSummary);

        case 2:
            // The vote was nominated

            if (RelatedPRI_1 == none)
            {
                break;
            }

            Output = Repl(default.VoteNominatedText, "{0}", RelatedPRI_1.PlayerName);

            if (Bytes[0] > 0)
            {
                Output @= Repl(default.VoteNominationsRemainingText, "{0}", Bytes[0]);
            }

            return Output;

        default:
            return "";
    }
}

defaultproperties
{
    VoteSucceededText="The vote to retreat has succeeded ({0})."
    VoteFailedText="The vote to retreat has failed ({0})."
    VoteSummaryText="Yes: {0}, Needed: {1}"
    VoteNominatedText="{0} has nominated to retreat."
    VoteNominationsRemainingText="Need {0} more nomination(s) to start the vote."
}
