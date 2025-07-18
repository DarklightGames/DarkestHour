//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetricsVehicleFrag extends JSONSerializable;

var class<DamageType>   DamageType;
var int                 RoundTime;

var string              KillerID;
var class<Pawn>         KillerPawn;
var Vector              KillerLocation;
var byte                KillerTeam;
var class<DHVehicle>    KillerVehicle;

var class<DHVehicle>    Vehicle;
var byte                VehicleTeam;
var Vector              VehicleLocation;

function JSONValue ToJSON()
{
    local JSONValue KillerPawnObject;
    local JSONValue KillerVehicleObject;

    if (KillerPawn != none)
    {
        KillerPawnObject = Class'JSONString'.static.Create(KillerPawn.Name);
    }

    if (KillerVehicle != none)
    {
        KillerVehicleObject = Class'JSONString'.static.Create(KillerVehicle.Name);
    }

    return (new Class'JSONObject')
        .PutString("damage_type", DamageType.Name)
        .PutInteger("time", RoundTime)
        .Put("killer", (new Class'JSONObject')
            .PutString("id", KillerID)
            .PutInteger("team", KillerTeam)
            .Put("pawn", KillerPawnObject)
            .PutIVector("location", KillerLocation)
            .Put("vehicle", KillerVehicleObject))
        .Put("destroyed_vehicle", (new Class'JSONObject')
            .PutString("vehicle", Vehicle.Name)
            .PutInteger("team", VehicleTeam)
            .PutIVector("location", VehicleLocation));
}
