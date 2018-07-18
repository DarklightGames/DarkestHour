//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHScoreEvent_VehicleKill extends DHScoreEvent;

var DHVehicle Vehicle;

static function DHScoreEvent_VehicleKill Create(DHVehicle Vehicle)
{
    local DHScoreEvent_VehicleKill ScoreEvent;

    ScoreEvent = new class'DHScoreEvent_VehicleKill';
    ScoreEvent.Vehicle = Vehicle;

    return ScoreEvent;
}

function int GetValue()
{
    return Vehicle.default.PointValue;
}

defaultproperties
{
    HumanReadableName="Vehicle Kill"
    CategoryClass=class'DHScoreCategory_Combat'
}

