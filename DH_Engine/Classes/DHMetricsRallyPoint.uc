//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMetricsRallyPoint extends JSONSerializable;

var int     TeamIndex;
var string  PlayerID;
var vector  Location;
var int     RoundTime;
var int     SpawnCount;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutInteger("team_index", TeamIndex)
        .PutString("player_id", PlayerID)
        .PutVector("location", Location)
        .PutInteger("created_at", RoundTime);
}

