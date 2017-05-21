//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHPlatoonHQMessage extends ROGameMessage
    abstract;

var localized string ActivatedMessage;
var localized string TeamCapturedMessage;
var localized string EnemyCapturedMessage;
var localized string DestroyedMessage;

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
            return default.ActivatedMessage;
        case 1:
            return default.TeamCapturedMessage;
        case 2:
            return default.EnemyCapturedMessage;
        case 3:
            return default.DestroyedMessage;
    }

    return "";
}

defaultproperties
{
    ActivatedMessage="A Platoon HQ has been established."
    TeamCapturedMessage="An enemy Platoon HQ has been captured."
    EnemyCapturedMessage="A Platoon HQ has been captured by the enemy."
    DestroyedMessage="A Platoon HQ has been destroyed."
}

