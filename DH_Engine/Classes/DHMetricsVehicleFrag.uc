//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMetricsVehicleFrag extends JSONSerializable;

var class<DamageType>   DamageType;
var int                 RoundTime;

var string              KillerID;
var class<Pawn>         KillerPawn;
var vector              KillerLocation;
var byte                KillerTeam;
var class<DHVehicle>    KillerVehicle;

var class<DHVehicle>    Vehicle;
var byte                VehicleTeam;
var vector              VehicleLocation;

function JSONValue ToJSON()
{
    local JSONValue KillerPawnObject;
    local JSONValue KillerVehicleObject;

    if (KillerPawn != none)
    {
        KillerPawnObject = class'JSONString'.static.Create(KillerPawn.Name);
    }

    if (KillerVehicle != none)
    {
        KillerVehicleObject = class'JSONString'.static.Create(KillerVehicle.Name);
    }

    return (new class'JSONObject')
        .PutString("damage_type", DamageType.Name)
        .PutInteger("time", RoundTime)
        .Put("killer", (new class'JSONObject')
            .PutString("id", KillerID)
            .PutInteger("team", KillerTeam)
            .Put("pawn", KillerPawnObject)
            .PutIVector("location", KillerLocation)
            .Put("vehicle", KillerVehicleObject))
        .Put("destroyed_vehicle", (new class'JSONObject')
            .PutString("vehicle", Vehicle.Name)
            .PutInteger("team", VehicleTeam)
            .PutIVector("location", VehicleLocation));
}
