//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetricsFrag extends JSONSerializable;

var class<DamageType>   DamageType;
var int                 HitIndex;
var int                 RoundTime;

var string              KillerID;
var class<Pawn>         KillerPawn;
var vector              KillerLocation;
var byte                KillerTeam;
var class<DHVehicle>    KillerVehicle;

var string              VictimID;
var class<Pawn>         VictimPawn;
var vector              VictimLocation;
var byte                VictimTeam;
var class<DHVehicle>    VictimVehicle;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutString("damage_type", DamageType.Name)
        .PutInteger("hit_index", HitIndex)
        .PutInteger("time", RoundTime)
        .Put("killer", (new class'JSONObject')
            .PutString("id", KillerID)
            .PutInteger("team", KillerTeam)
            .PutString("pawn", KillerPawn.Name)
            .PutIVector("location", KillerLocation)
            .PutString("vehicle", KillerVehicle.Name))
        .Put("victim", (new class'JSONObject')
            .PutString("id", VictimID)
            .PutInteger("team", VictimTeam)
            .PutString("pawn", VictimPawn.Name)
            .PutIVector("location", VictimLocation)
            .PutString("vehicle", VictimVehicle.Name));
}

