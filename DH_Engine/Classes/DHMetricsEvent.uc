//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetricsEvent extends JSONSerializable;

var string Type;
var JSONObject Data;

function JSONValue ToJSON()
{
    local JSONObject JSON;

    JSON = new class'JSONObject';
    JSON.PutString("type", Type);
    JSON.Put("data", Data);

    return JSON;
}

defaultproperties
{
}

