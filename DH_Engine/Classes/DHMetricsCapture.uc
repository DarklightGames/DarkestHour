//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
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
        .PutInteger("team_index", TeamIndex)
        .Put("player_ids", class'JSONArray'.static.FromStrings(PlayerIDs));
}

