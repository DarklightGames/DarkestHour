//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Stug3GFactory_SnowTwo extends DH_Stug3GFactory_Late_Snow // just a legacy class for backwards compatibility, as SnowTwo version was renamed to Late_Snow
    notplaceable;                                                 // TODO - this class should be removed in some future release when people have had time to convert maps to new actor

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Log("Leveller, please replace DH_Stug3GFactory_SnowTwo with DH_Stug3GFactory_Late_Snow, as this is a temporary legacy actor & in future the map will break", 'MAP WARNING');
    }
}
