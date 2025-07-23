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
    DarkestHourGame(Level.Game).OnArtilleryFired(
        0,
        Location
    );
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
    DeviationRange=(Min=25,Max=100)
    bHidden=true
    LifeSpan=30
}