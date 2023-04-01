//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BoatBlockingVolume extends BlockingVolume;

defaultproperties
{
    bClassBlocker=true
    BlockedClasses(0)=class'DH_Vehicles.DH_HigginsBoat'
    BlockedClasses(1)=class'DH_Vehicles.DH_DUKWTransport'
    bBlockZeroExtentTraces=true
}
