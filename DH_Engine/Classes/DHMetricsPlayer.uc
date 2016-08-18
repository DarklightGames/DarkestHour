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
    local JSONObject O;

    O = new class'JSONObject';
    O.PutString("id", ID);
    O.Put("names", class'JSONArray'.static.CreateFromStringArray(Names));
    O.PutString("ip", NetworkAddress);

    return O;
}
