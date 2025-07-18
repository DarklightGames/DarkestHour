//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_JagdtigerMountedMG extends DH_PanzerIVMountedMG;

defaultproperties
{
    MaxPositiveYaw=4000 // TODO: check why/if yaw & pitch should differ from KT
    MaxNegativeYaw=-4000
    NumMGMags=8
    FireEffectOffset=(X=-60.0,Y=0.0,Z=30.0) // positions fire on co-driver's hatch
}
