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
    local int i, m;

    m = MapList.Length;

    // Parse and assign the MapListObjects if the string is parseable
    if ((new class'JSONParser').ParseObject(MapInfo.MapName) != none)
    {
        i = MapListObjects.Length;
        MapListObjects[i] = (new class'JSONParser').ParseObject(MapInfo.MapName);

        // Update the map info
        MapInfo.MapName = MapListObjects[i].Get("MapName").AsString();
    }

    // Update the MapList and assign index in MapNameIndices
    MapList[m] = MapInfo;
    MapNameIndices.Put(MapInfo.MapName, m);

    DebugLog("___Receiving - " $ MapInfo.MapName);
    ReplicationReply();
}
