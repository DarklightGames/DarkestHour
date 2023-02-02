//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMetricsRound extends JSONSerializable;

var DateTime                        StartedAt;
var DateTime                        EndedAt;
var array<DHMetricsRound>           Rounds;
var array<DHMetricsFrag>            Frags;
var array<DHMetricsVehicleFrag>     VehicleFrags;
var array<DHMetricsCapture>         Captures;
var array<DHMetricsConstruction>    Constructions;
var array<DHMetricsRallyPoint>      RallyPoints;
var array<JSONObject>               Events;
var int                             Winner;

function JSONValue ToJSON()
{
    local JSONObject JSON;

    JSON = (new class'JSONObject')
        .PutString("started_at", StartedAt.IsoFormat())
        .PutInteger("winner", Winner)
        .Put("frags", class'JSONArray'.static.FromSerializables(Frags))
        .Put("vehicle_frags", class'JSONArray'.static.FromSerializables(VehicleFrags))
        .Put("captures", class'JSONArray'.static.FromSerializables(Captures))
        .Put("constructions", class'JSONArray'.static.FromSerializables(Constructions))
        .Put("rally_points", class'JSONArray'.static.FromSerializables(RallyPoints))
        .Put("events", class'JSONArray'.static.FromValues(Events));

    if (EndedAt == none)
    {
        JSON.PutNull("ended_at");
    }
    else
    {
        JSON.PutString("ended_at", EndedAt.IsoFormat());
    }

    return JSON;
}

defaultproperties
{
    Winner=-1
}

