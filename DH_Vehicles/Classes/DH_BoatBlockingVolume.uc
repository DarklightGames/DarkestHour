//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_BoatBlockingVolume extends BlockingVolume;

defaultproperties
{
    bClassBlocker=true
    BlockedClasses(0)=class'DH_Vehicles.DH_HigginsBoat'
    bBlockZeroExtentTraces=true
}
