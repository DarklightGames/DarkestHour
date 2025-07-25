//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCommandPostMessage extends ROGameMessage
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
    local string S;
    local class<DHConstruction> ConstructionClass;

    switch (Switch)
    {
        case 0:
            S = default.ActivatedMessage;
            break;
        case 2:
            S = default.OverrunMessage;
            break;
        case 3:
            S = default.DestroyedMessage;
            break;
        case 4:
            S = Repl(default.ConstructedMessage, "{seconds}", Class'DHSpawnPoint_PlatoonHQ'.default.EstablishmentCounterThreshold);
            break;
    }

    ConstructionClass = class<DHConstruction>(OptionalObject);

    if (ConstructionClass != none)
    {
        S = Repl(S, "{name}", ConstructionClass.default.MenuName);
    }

    return S;
}

defaultproperties
{
    DrawColor=(R=225,G=105,B=45,A=255)
    ActivatedMessage="A {name} has been established."
    OverrunMessage="A {name} has been overrun by the enemy."
    DestroyedMessage="A {name} has been destroyed."
    ConstructedMessage="A {name} has been constructed and will be established in {seconds} seconds."
}

