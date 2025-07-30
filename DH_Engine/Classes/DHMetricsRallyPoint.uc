//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetricsRallyPoint extends JSONSerializable;

enum EDestroyedReason
{
    REASON_None,
    REASON_Overrun,     // An enemy soldier came too close
    REASON_Exhausted,   // All spawns were exhausted
    REASON_Damaged,     // Was critically damaged
    REASON_Deleted,     // Squad leader forcibly deleted the rally point
    REASON_Replaced,    // A new rally point was created while at max rally points
    REASON_SpawnKill,   // Player was killed immediately after spawning
    REASON_Abandoned,   // No squadmates nearby to establish
    REASON_Encroached,  // Persistent nearby enemy presence
};

var int                 TeamIndex;
var int                 SquadIndex;
var string              PlayerID;
var Vector              Location;
var int                 SpawnCount;
var bool                bIsEstablished;
var int                 EstablisherCount;
var DateTime            CreatedAt;
var DateTime            DestroyedAt;
var EDestroyedReason    DestroyedReason;

static function JSONValue GetDestroyedReasonValue(EDestroyedReason DestroyedReason)
{
    switch (DestroyedReason)
    {
        case REASON_Overrun:
            return Class'JSONString'.static.Create("overrun");
        case REASON_Exhausted:
            return Class'JSONString'.static.Create("exhausted");
        case REASON_Damaged:
            return Class'JSONString'.static.Create("damaged");
        case REASON_Deleted:
            return Class'JSONString'.static.Create("deleted");
        case REASON_Replaced:
            return Class'JSONString'.static.Create("replaced");
        case REASON_SpawnKill:
            return Class'JSONString'.static.Create("spawn_kill");
        case REASON_Abandoned:
            return Class'JSONString'.static.Create("abandoned");
        case REASON_Encroached:
            return Class'JSONString'.static.Create("encroached");
    }

    return Class'JSONLiteral'.static.CreateNull();
}

function JSONValue ToJSON()
{
    local JSONObject JSON;

    JSON = (new Class'JSONObject')
        .PutInteger("team_index", TeamIndex)
        .PutInteger("squad_index", SquadIndex)
        .PutString("player_id", PlayerID)
        .PutBoolean("is_established", bIsEstablished)
        .PutInteger("establisher_count", EstablisherCount)
        .PutVector("location", Location)
        .PutString("created_at", CreatedAt.IsoFormat())
        .Put("destroyed_reason", GetDestroyedReasonValue(DestroyedReason))
        .PutInteger("spawn_count", SpawnCount);

    // TODO: improve the underlying JSON structure so we can just pass the DateTime
    // object, null or not, and have it serialize correctly.
    if (DestroyedAt == none)
    {
        JSON.PutNull("destroyed_at");
    }
    else
    {
        JSON.PutString("destroyed_at", DestroyedAt.IsoFormat());
    }

    return JSON;
}

