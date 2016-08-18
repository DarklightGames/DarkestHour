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

    // Damage Type
    Root.PutString("damage_type", DamageType.Name);
    Root.PutInteger("hit_index", HitIndex);

    // Killer
    KillerObject = new class'JSONObject';
    KillerObject.PutString("id", KillerID);
    KillerObject.Put("location", class'JSONArray'.static.ICreateFromVector(KillerLocation));
    KillerObject.PutInteger("team", KillerTeam);

    Root.Put("killer", KillerObject);

    // Victim
    VictimObject = new class'JSONObject';
    VictimObject.PutString("id", VictimID);
    VictimObject.Put("location", class'JSONArray'.static.ICreateFromVector(VictimLocation));
    VictimObject.PutInteger("team", VictimTeam);

    Root.Put("victim", VictimObject);

    return Root;
}
