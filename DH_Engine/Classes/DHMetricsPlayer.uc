//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetricsPlayer extends JSONSerializable;

var string                          ID;
var array<string>                   Names;
var array<string>                   ClientGUIDs;
var array<DHMetricsPlayerSession>   Sessions;

function JSONValue ToJSON()
{
    return (new Class'JSONObject')
        .PutString("id", ID)
        .Put("names", Class'JSONArray'.static.FromStrings(Names))
        .Put("client_guids", Class'JSONArray'.static.FromStrings(ClientGUIDs))
        .Put("sessions", Class'JSONArray'.static.FromSerializables(Sessions));
}

