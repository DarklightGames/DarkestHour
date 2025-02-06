//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BoatBlockingVolume extends BlockingVolume;

defaultproperties
{
    bClassBlocker=true
    BlockedClasses(0)=class'DH_Vehicles.DH_HigginsBoat'
    BlockedClasses(1)=class'DH_Vehicles.DH_DUKW'
    bBlockZeroExtentTraces=true
}
