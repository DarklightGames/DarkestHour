//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSpawnArea extends ROSpawnArea
    placeable;

var()   bool    bMortarmanSpawnArea;

function PostBeginPlay()
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        if (bTankCrewSpawnArea)
        {
            G.TankCrewSpawnAreas[G.TankCrewSpawnAreas.Length] = self;
        }
        else if (bMortarmanSpawnArea)
        {
            G.DHMortarSpawnAreas[G.DHMortarSpawnAreas.Length] = self;
        }
        else
        {
            G.SpawnAreas[G.SpawnAreas.Length] = self;
        }
    }

    if (VolumeTag != '')
    {
        foreach AllActors(Class'Volume', AttachedVolume, VolumeTag)
        {
            AttachedVolume.AssociatedActor = self;

            break;
        }
    }

    Disable('Trigger');
}
