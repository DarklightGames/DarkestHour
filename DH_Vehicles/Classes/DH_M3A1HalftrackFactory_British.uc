//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// LEGACY class for backwards compatibility as there's no longer any separate vehicle skin with British markings
// The new (from DH v8.0) M3 halftrack skin is generic, with allies markings but not nation or unit specific decals
// TODO - this class should be removed in some future release when people have had time to convert maps to new actor

class DH_M3A1HalftrackFactory_British extends DH_M3A1HalftrackFactory;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Log("Leveller, please replace use of DH_M3A1HalftrackFactory_British with DH_M3A1HalftrackFactory, as this is a temporary legacy actor & in future the map will break", 'MAP WARNING');
    }
}
