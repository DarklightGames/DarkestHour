//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Tiger2BMountedMG extends DH_PanzerIVMountedMG;

defaultproperties
{
    MaxPositiveYaw=7000
    MaxNegativeYaw=-7000
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63000
    NumMGMags=10
    FireEffectOffset=(X=-60.0,Y=0.0,Z=30.0) // positions fire on co-driver's hatch
}
