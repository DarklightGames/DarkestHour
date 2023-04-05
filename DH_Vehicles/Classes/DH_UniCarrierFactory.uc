//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_UniCarrierFactory extends DH_BrenCarrierFactory // just a legacy class for backwards compatibility, as UniCarrier version was renamed to BrenCarrier
    notplaceable;                                        // TODO - this class should be removed in some future release when people have had time to convert maps to new actor

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Log("Leveller, please replace DH_UniCarrierFactory with DH_BrenCarrierFactory, as this is a temporary legacy actor & in future the map will break", 'MAP WARNING');
    }
}
