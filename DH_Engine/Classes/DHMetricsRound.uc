//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

    JSON = (new Class'JSONObject')
        .PutString("started_at", StartedAt.IsoFormat())
        .PutInteger("winner", Winner)
        .Put("frags", Class'JSONArray'.static.FromSerializables(Frags))
        .Put("vehicle_frags", Class'JSONArray'.static.FromSerializables(VehicleFrags))
        .Put("captures", Class'JSONArray'.static.FromSerializables(Captures))
        .Put("constructions", Class'JSONArray'.static.FromSerializables(Constructions))
        .Put("rally_points", Class'JSONArray'.static.FromSerializables(RallyPoints))
        .Put("events", Class'JSONArray'.static.FromValues(Events));

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

