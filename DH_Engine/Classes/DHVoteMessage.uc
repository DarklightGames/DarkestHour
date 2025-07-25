//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVoteMessage extends ROGameMessage;

var localized string VoteReceievedText;
var localized string VoteConcludedText;

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (S)
    {
        case 0:
            return default.VoteReceievedText;
        default:
            return "";
    }
}

defaultproperties
{
    VoteReceievedText="Your vote has been received."
    VoteConcludedText="The vote has concluded."
}

