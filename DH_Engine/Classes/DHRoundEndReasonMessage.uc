//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHRoundEndReasonMessage extends ROGameMessage;

var localized string TeamSurrenderedMessage;

static function string GetString(
    optional int Switch, 
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject
    )
{
    switch (Switch)
    {
        case 0: // REASON_Surrendered
            return default.TeamSurrenderedMessage;
        default:
            return "";
    }
}

defaultproperties
{
    TeamSurrenderedMessage="The round has ended because a team voted to retreat."
}
