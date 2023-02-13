//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherMountedMG extends DH_PanzerIVMountedMG;

defaultproperties
{
    MaxPositiveYaw=4500
    MaxNegativeYaw=-4500
    CustomPitchUpLimit=2730
    CustomPitchDownLimit=64000
    NumMGMags=9
    FireEffectOffset=(X=-50.0,Y=0.0,Z=30.0) // positions fire on co-driver's hatch
}
