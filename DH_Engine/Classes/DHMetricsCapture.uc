//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetricsCapture extends JSONSerializable;

var int             ObjectiveIndex;
var int             RoundTime;
var int             TeamIndex;
var array<string>   PlayerIDs;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutInteger("objective_id", ObjectiveIndex)
        .PutInteger("round_time", RoundTime)
        .PutInteger("team", TeamIndex)
        .Put("player_ids", class'JSONArray'.static.FromStrings(PlayerIDs));
}

