//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMetricsPlayer extends JSONSerializable;

var string                          ID;
var array<string>                   Names;
var array<string>                   ClientGUIDs;
var array<DHMetricsPlayerSession>   Sessions;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutString("id", ID)
        .Put("names", class'JSONArray'.static.FromStrings(Names))
        .Put("client_guids", class'JSONArray'.static.FromStrings(ClientGUIDs))
        .Put("sessions", class'JSONArray'.static.FromSerializables(Sessions));
}

