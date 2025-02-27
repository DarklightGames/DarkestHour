//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetricsConstruction extends JSONSerializable;

var int                     TeamIndex;
var class<DHConstruction>   ConstructionClass;
var vector                  Location;
var int                     RoundTime;
var string                  PlayerID;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutInteger("team", TeamIndex)
        .PutInteger("round_time", RoundTime)
        .PutString("class", ConstructionClass)
        .PutVector("location", Location)
        .PutString("player_id", PlayerID);
}

