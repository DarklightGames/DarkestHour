//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPlatoonHQMessage extends ROGameMessage
    abstract;

var localized string ActivatedMessage;
var localized string OverrunMessage;
var localized string DestroyedMessage;
var localized string ConstructedMessage;

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
        case 2:
            return default.OverrunMessage;
        case 3:
            return default.DestroyedMessage;
        case 4:
            return Repl(default.ConstructedMessage, "{0}", class'DHSpawnPoint_PlatoonHQ'.default.EstablishmentCounterThreshold);
    }

    return "";
}

defaultproperties
{
    DrawColor=(R=225,G=105,B=45,A=255)
    ActivatedMessage="A Platoon HQ has been established."
    OverrunMessage="A Platoon HQ has been overrun by the enemy."
    DestroyedMessage="A Platoon HQ has been destroyed."
    ConstructedMessage="A Platoon HQ has been constructed and will be established in {0} seconds."
}

