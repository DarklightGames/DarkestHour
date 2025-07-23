//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCounterBatteryManager extends Actor
    notplaceable;

var int     TeamIndex;
var Range   DeviationRange;

function OnArtilleryFired(Vector WorldLocation)
{
    local Controller C;
    local DHPlayer PC;
    local Vector MarkerLocation;
    local float Deviation, Theta;
    
    // Get a random range deviation using a uniform distribution so that it's spread evenly.
    Deviation = DeviationRange.Max * Sqrt(FRand());
    Deviation = class'DHUnits'.static.MetersToUnreal(Deviation);

    // Pick a random direction for the deviation.
    Theta = FRand() * Pi * 2;

    MarkerLocation = WorldLocation;
    MarkerLocation.X += Cos(Theta) * Deviation;
    MarkerLocation.Y += Sin(Theta) * Deviation;

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

defaultproperties
{
    RemoteRole=ROLE_None
    DeviationRange=(Min=50,Max=100)
}
