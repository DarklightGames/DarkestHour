//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BoatBlockingVolume extends BlockingVolume;

defaultproperties
{
    bClassBlocker=true
    BlockedClasses(0)=Class'DH_HigginsBoat'
    BlockedClasses(1)=Class'DH_DUKW'
    bBlockZeroExtentTraces=true
}
