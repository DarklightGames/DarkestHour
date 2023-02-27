//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
        foreach AllActors(class'Volume', AttachedVolume, VolumeTag)
        {
            AttachedVolume.AssociatedActor = self;

            break;
        }
    }

    Disable('Trigger');
}
