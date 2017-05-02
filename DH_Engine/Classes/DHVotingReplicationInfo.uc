//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVotingReplicationInfo extends VotingReplicationInfo;

var array<JSONObject>               MapListObjects;

var TreeMap_string_int              MapNameIndices;

simulated function PostBeginPlay()
{
    MapNameIndices = new class'TreeMap_string_int';

    super.PostBeginPlay();
}

simulated function int GetMapIndex(string MapName)
{
    local int Index;

    if (MapNameIndices != none && MapNameIndices.Get(MapName, Index))
    {
        return Index;
    }

    return -1;
}

// Once the client has received the map info, have them parse the string into JSON object and save into array
simulated function ReceiveMapInfo(VotingHandler.MapVoteMapList MapInfo)
{
    local int i;

    MapList[MapList.Length] = MapInfo;

    if (MapNameIndices == none)
    {
        Log("Oh no! we don't have any beer here");
    }

    MapNameIndices.Put(MapInfo.MapName, MapList.Length);

    if ((new class'JSONParser').ParseObject(MapInfo.MapName) != none)
    {
        i = MapListObjects.Length;
        MapListObjects[i] = (new class'JSONParser').ParseObject(MapInfo.MapName);
        MapInfo.MapName = MapListObjects[i].Get("MapName").AsString();
        Log("Adding this map to MapListObjects:" @ MapInfo.MapName);
    }

    Log("MapNames:" @ MapInfo.MapName);

    DebugLog("___Receiving - " $ MapInfo.MapName);
    ReplicationReply();
}
