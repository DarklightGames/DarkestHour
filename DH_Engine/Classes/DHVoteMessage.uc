
class DHVoteMessage extends LocalMessage;

var localized string VoteReceievedText;

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
    VoteReceievedText="Your vote has been recieved."
}

