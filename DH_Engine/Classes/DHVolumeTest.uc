//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVolumeTest extends ROVolumeTest;

// Returns true if this test actor is in an area where artillery should not be allowed
function bool IsInNoArtyVolume()
{
    local Volume V;

    foreach TouchingActors(class'Volume', V)
    {
        if ((V.AssociatedActor != none && V.AssociatedActor.IsA('ROSpawnArea') && IsCurrentSpawnArea(ROSpawnArea(V.AssociatedActor))) ||
            (V.IsA('RONoArtyVolume') && (IsCurrentSpawnArea(RONoArtyVolume(V).AssociatedSpawn) || RONoArtyVolume(V).SpawnAreaTag == '')) ||
            (V.IsA('DHMineVolume') && DHMineVolume(V).bIsAlsoNoArtyVolume && DHMineVolume(V).bActive))
        {
            return true;
        }
    }

    return false;
}

defaultproperties
{
}