//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCounterBatteryMarkerEmitter extends Actor
    notplaceable;

var Range   DeviationRange; // In meters.
var int     TeamIndex;

function EmitMarker()
{
    local Controller C;
    local DHPlayer PC;
    local Vector MarkerLocation;
    local float Deviation, Theta;
    
    // Get a random range deviation (in future have this based on sound ranging factors)
    Deviation = RandRange(DeviationRange.Min, DeviationRange.Max);
    Deviation = class'DHUnits'.static.MetersToUnreal(Deviation);

    // Pick a random direction for the deviation.
    Theta = FRand() * Pi * 2;

    MarkerLocation = Location;
    MarkerLocation.X = Cos(Theta) * Deviation;
    MarkerLocation.Y = Sin(Theta) * Deviation;

    // TODO: abstract this elsewhere so we can call it from game class, perhaps.
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        PC = DHPlayer(C);

        if (PC == none)
        {
            continue;
        }

        PC.ClientAddPersonalMapMarker(class'DHMapMarker_CounterBattery', MarkerLocation);
    }
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    SetTimer(1.0, false);
}

event Timer()
{
    EmitMarker();
    SetTimer(RandRange(4, 5), false);
}

defaultproperties
{
    DeviationRange=(Min=20,Max=50)
    bHidden=true
    LifeSpan=30
}