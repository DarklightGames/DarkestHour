//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetricsVehicleFrag extends JSONSerializable;

var class<DamageType>   DamageType;
var int                 RoundTime;

var string              KillerID;
var class<Pawn>         KillerPawn;
var vector              KillerLocation;
var byte                KillerTeam;
var class<DHVehicle>    KillerVehicle;
var class<Vehicle>      KillerVehicleSeat;

var class<DHVehicle>    Vehicle;
var byte                VehicleTeam;
var vector              VehicleLocation;

function JSONValue ToJSON()
{
    return (new class'JSONObject')
        .PutString("damage_type", DamageType.Name)
        .PutInteger("time", RoundTime)
        .Put("killer", (new class'JSONObject')
            .PutString("id", KillerID)
            .PutInteger("team", KillerTeam)
            .PutString("pawn", KillerPawn.Name)
            .PutIVector("location", KillerLocation)
            .PutString("vehicle", KillerVehicle.Name))
        .Put("destroyed_vehicle", (new class'JSONObject')
            .PutString("vehicle", Vehicle.Name)
            .PutInteger("team", VehicleTeam)
            .PutIVector("location", VehicleLocation));
}
