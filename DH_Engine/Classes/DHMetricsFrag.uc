//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetricsFrag extends JSONSerializable;

var class<DamageType>   DamageType;
var string              KillerID;
var vector              KillerLocation;
var byte                KillerTeam;
var string              VictimID;
var vector              VictimLocation;
var byte                VictimTeam;
var int                 HitIndex;

function JSONValue ToJSON()
{
    local JSONObject Root;
    local JSONObject KillerObject;
    local JSONObject VictimObject;

    Root = new class'JSONObject';

    Log("A");

    // Damage Type
    Root.PutString("damage_type", DamageType.Name);
    Root.PutInteger("hit_index", HitIndex);

    Log("B");

    // Killer
    KillerObject = new class'JSONObject';
    KillerObject.PutString("id", KillerID);
    KillerObject.Put("location", class'JSONArray'.static.CreateFromVector(KillerLocation));
    KillerObject.PutInteger("team", KillerTeam);

    Root.Put("killer", KillerObject);

    Log("C");

    // Victim
    VictimObject = new class'JSONObject';
    VictimObject.PutString("id", VictimID);
    VictimObject.Put("location", class'JSONArray'.static.CreateFromVector(VictimLocation));
    VictimObject.PutInteger("team", VictimTeam);

    Log("D");

    Root.Put("victim", VictimObject);

    Log("Z");

    return Root;
}
