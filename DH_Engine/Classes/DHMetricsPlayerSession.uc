//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetricsPlayerSession extends JSONSerializable;

var string NetworkAddress;
var DateTime StartedAt;
var DateTime EndedAt;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutString("ip", NetworkAddress)
        .PutString("started_at", StartedAt.IsoFormat())
        .PutString("ended_at", EndedAt.IsoFormat());
}

