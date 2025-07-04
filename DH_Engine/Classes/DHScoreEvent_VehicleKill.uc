//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_VehicleKill extends DHScoreEvent;

var class<DHVehicle> VehicleClass;

static function DHScoreEvent_VehicleKill Create(class<DHVehicle> VehicleClass)
{
    local DHScoreEvent_VehicleKill ScoreEvent;

    ScoreEvent = new Class'DHScoreEvent_VehicleKill';
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
    CategoryClass=Class'DHScoreCategory_Combat'
}

