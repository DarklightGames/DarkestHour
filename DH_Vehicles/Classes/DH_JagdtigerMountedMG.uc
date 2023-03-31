//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdtigerMountedMG extends DH_PanzerIVMountedMG;

defaultproperties
{
    MaxPositiveYaw=4000 // TODO: check why/if yaw & pitch should differ from KT
    MaxNegativeYaw=-4000
    NumMGMags=8
    FireEffectOffset=(X=-60.0,Y=0.0,Z=30.0) // positions fire on co-driver's hatch
}
