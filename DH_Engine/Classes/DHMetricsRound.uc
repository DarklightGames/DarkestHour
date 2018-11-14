//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetricsRound extends JSONSerializable;

var DateTime                        StartedAt;
var DateTime                        EndedAt;
var array<DHMetricsRound>           Rounds;
var array<DHMetricsFrag>            Frags;
var array<DHMetricsCapture>         Captures;
var array<DHMetricsConstruction>    Constructions;
var int                             Winner;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutString("started_at", StartedAt.IsoFormat())
        .PutString("ended_at", EndedAt.IsoFormat())
        .PutInteger("winner", Winner)
        .Put("frags", class'JSONArray'.static.FromSerializables(Frags))
        .Put("captures", class'JSONArray'.static.FromSerializables(Captures))
        .Put("constructions", class'JSONArray'.static.FromSerializables(Constructions));
}

defaultproperties
{
    Winner=-1
}

