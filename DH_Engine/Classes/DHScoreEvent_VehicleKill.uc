//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreEvent_VehicleKill extends DHScoreEvent;

var class<DHVehicle> VehicleClass;

static function DHScoreEvent_VehicleKill Create(class<DHVehicle> VehicleClass)
{
    local DHScoreEvent_VehicleKill ScoreEvent;

    ScoreEvent = new class'DHScoreEvent_VehicleKill';
    ScoreEvent.VehicleClass = VehicleClass;

    return ScoreEvent;
}

function int GetValue()
{
    return VehicleClass.default.PointValue;
}

defaultproperties
{
    HumanReadableName="Vehicle Kill"
    CategoryClass=class'DHScoreCategory_Combat'
}

