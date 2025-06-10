//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetricsFrag extends JSONSerializable;

var class<DamageType>   DamageType;
var int                 HitIndex;
var int                 RoundTime;

var string              KillerID;
var class<Pawn>         KillerPawn;
var Vector              KillerLocation;
var byte                KillerTeam;
var class<DHVehicle>    KillerVehicle;

var string              VictimID;
var class<Pawn>         VictimPawn;
var Vector              VictimLocation;
var byte                VictimTeam;
var class<DHVehicle>    VictimVehicle;

function JSONValue ToJSON()
{
    local JSONValue KillerVehicleObject;
    local JSONValue VictimVehicleObject;

    if (KillerVehicle != none)
    {
        KillerVehicleObject = Class'JSONString'.static.Create(KillerVehicle.Name);
    }

    if (VictimVehicle != none)
    {
        VictimVehicleObject = Class'JSONString'.static.Create(VictimVehicle.Name);
    }

    return (new Class'JSONObject')
        .PutString("damage_type", DamageType.Name)
        .PutInteger("hit_index", HitIndex)
        .PutInteger("time", RoundTime)
        .Put("killer", (new Class'JSONObject')
            .PutString("id", KillerID)
            .PutInteger("team", KillerTeam)
            .PutString("pawn", KillerPawn.Name)
            .PutIVector("location", KillerLocation)
            .Put("vehicle", KillerVehicleObject))
        .Put("victim", (new Class'JSONObject')
            .PutString("id", VictimID)
            .PutInteger("team", VictimTeam)
            .PutString("pawn", VictimPawn.Name)
            .PutIVector("location", VictimLocation)
            .Put("vehicle", VictimVehicleObject));
}
