//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BurningVolume extends DHBurningVolume // just a legacy class for backwards compatibility, as DHBurningVolume is now in DH_Engine code package
    placeable;                                 // TODO - this class should be removed in some future release when people have had time to convert maps to the new actor
                                               // NOTE: making this actor notplacable would not result in it being deleted from maps when rebuilt, but would stop it being added
/*
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Log("Leveller, please replace DH_BurningVolume actors with DHBurningVolume, as this is a temporary legacy actor & in future the map will break", 'MAP WARNING');
    }
}
*/
