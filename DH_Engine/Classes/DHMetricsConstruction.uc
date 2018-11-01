//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetricsConstruction extends JSONSerializable;

var int                     TeamIndex;
var class<DHConstruction>   ConstructionClass;
var vector                  Location;
var int                     RoundTime;
var int                     Yaw;
var string                  PlayerID;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutInteger("team_index", TeamIndex)
        .PutInteger("round_time", RoundTime)
        .PutString("class", ConstructionClass)
        .PutVector("location", Location)
        .PutInteger("yaw", Yaw)
        .PutString("player_id", PlayerID);
}

