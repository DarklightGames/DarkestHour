//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCounterBatteryMarkerEmitter extends Actor
    notplaceable;

var int     TeamIndex;

function EmitMarker()
{
    DarkestHourGame(Level.Game).OnArtilleryFired(TeamIndex, None, Location);
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
    bHidden=true
    LifeSpan=30
}