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
var int                 RoundTime;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutString("damage_type", DamageType.Name)
        .PutInteger("hit_index", HitIndex)
        .PutInteger("time", RoundTime)
        .Put("killer", (new class'JSONObject')
            .PutString("id", KillerID)
            .PutInteger("team", KillerTeam)
            .PutIVector("location", KillerLocation))
        .Put("victim", (new class'JSONObject')
            .PutString("id", VictimID)
            .PutInteger("team", VictimTeam)
            .PutIVector("location", VictimLocation));
}

