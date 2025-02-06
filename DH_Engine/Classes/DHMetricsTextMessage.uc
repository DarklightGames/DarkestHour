//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetricsTextMessage extends JSONSerializable;

var string Type;
var string Message;
var string ROID;
var DateTime SentAt;
var int TeamIndex;
var int SquadIndex;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutString("type", Type)
        .PutString("message", Message)
        .PutString("sender", ROID)
        .PutString("sent_at", SentAt.IsoFormat())
        .PutInteger("team_index", TeamIndex)
        .PutInteger("squad_index", SquadIndex);
}

