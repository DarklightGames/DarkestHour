//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHVolumeTest extends ROVolumeTest;

// Modified to handle no arty volumes that are linked to a DHSpawnPoint (as well as an old spawn area) or to a DHObjective
// Also to handle DHMineVolumes that use the option to also act as a NoArtyVolume
function bool IsInNoArtyVolume()
{
    local Volume V;

    foreach TouchingActors(class'Volume', V)
    {
        // Prevent arty if we're in a no arty volume, unless it's linked to a spawn point/area that isn't active/current
        if (V.IsA('RONoArtyVolume'))
        {
            Log("0");
            if (DHSpawnPoint(V.AssociatedActor) != none)
            {
                if (IsActiveSpawnPoint(DHSpawnPoint(V.AssociatedActor)))
                {
                    Log("1");
                    return true;
                }
            }
            else if (RONoArtyVolume(V).AssociatedSpawn != none)
            {
                if (IsCurrentSpawnArea(RONoArtyVolume(V).AssociatedSpawn))
                {
                    Log("2");
                    return true;
                }
            }
            else if (DHObjective(V.AssociatedActor) != none)
            {
                if (DHObjective(V.AssociatedActor).IsActive())
                {
                    Log("3");
                    return true;
                }
            }
            else
            {
                Log("4");
                return true;
            }
        }
        // Prevent arty if we're in an active mine volume that is set to also function as a no arty volume
        else if (V.IsA('DHMineVolume'))
        {
            Log("5");
            Log("DHMineVolume(V).bIsAlsoNoArtyVolume:"@DHMineVolume(V).bIsAlsoNoArtyVolume);
            Log("DHMineVolume(V).bClientActive:"@DHMineVolume(V).bClientActive);
            // Log("DHMineVolume(V).ServerMineVolumeActive():"@DHMineVolume(V).ServerMineVolumeActive());
            if (DHMineVolume(V).bIsAlsoNoArtyVolume && DHMineVolume(V).bClientActive)
            {
                Log("6");
                return true;
            }
        }
        // Prevent arty if we're in a current spawn area's protective volume
        else if (V.AssociatedActor != none && V.AssociatedActor.IsA('ROSpawnArea') && IsCurrentSpawnArea(ROSpawnArea(V.AssociatedActor)))
        {
            Log("V.AssociatedActor:"@V.AssociatedActor);
            Log("V.AssociatedActor.IsA('ROSpawnArea')"@V.AssociatedActor.IsA('ROSpawnArea'));
            Log("IsCurrentSpawnArea(ROSpawnArea(V.AssociatedActor))"@IsCurrentSpawnArea(ROSpawnArea(V.AssociatedActor)));
            Log("7");
            return true;
        }
    }

    Log("8");
    return false;
}

// New helper function returns true if this DHSpawnPoint is active (just improves readability in main class function above)
// (Similar to IsCurrentSpawnArea() for spawn areas)
function bool IsActiveSpawnPoint(DHSpawnPoint SP)
{
    return SP != none && SP.IsActive();
}

defaultproperties
{
}
