//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetricsPlayer extends JSONSerializable;

var string          ID;
var array<string>   Names;
var string          NetworkAddress;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutString("id", ID)
        .Put("names", class'JSONArray'.static.FromStrings(Names))
        .PutString("ip", NetworkAddress);
}

