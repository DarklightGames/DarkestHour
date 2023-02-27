//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Stug3GFactory_CamoTwo extends DH_Stug3GFactory_Late // just a legacy class for backwards compatibility, as CamoTwo version was renamed to 'Late'
    notplaceable;                                            // TODO - this class should be removed in some future release when people have had time to convert maps to new actor

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Log("Leveller, please replace DH_Stug3GFactory_CamoTwo with DH_Stug3GFactory_Late, as this is a temporary legacy actor & in future the map will break", 'MAP WARNING');
    }
}
