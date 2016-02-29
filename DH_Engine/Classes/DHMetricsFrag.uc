//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetricsFrag extends Object;

var class<DamageType>   DamageType;
var string              KillerID;
var vector              KillerLocation;
var byte                KillerTeam;
var string              VictimID;
var vector              VictimLocation;
var byte                VictimTeam;
var int                 HitIndex;

function JSONObject EncodeJSON()
{
    local JSONObject Root;
    local JSONObject KillerObject;
    local JSONObject VictimObject;

    Root = new class'JSONObject';

    // Damage Type
    Root.Put("damage_type", class'JSONString'.static.Create(string(DamageType.Name)));
    Root.Put("hit_index", class'JSONNumber'.static.ICreate(HitIndex));

    // Killer
    KillerObject = new class'JSONObject';
    KillerObject.Put("id", class'JSONString'.static.Create(KillerID));
    KillerObject.Put("location", class'JSONArray'.static.VCreate(KillerLocation));
    KillerObject.Put("team", class'JSONNumber'.static.ICreate(KillerTeam));

    Root.Put("killer", KillerObject);

    // Victim
    VictimObject = new class'JSONObject';
    VictimObject.Put("id", class'JSONString'.static.Create(VictimID));
    VictimObject.Put("location", class'JSONArray'.static.VCreate(VictimLocation));
    VictimObject.Put("team", class'JSONNumber'.static.ICreate(VictimTeam));

    Root.Put("victim", VictimObject);

    return Root;
}

