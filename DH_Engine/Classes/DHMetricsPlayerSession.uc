//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
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

