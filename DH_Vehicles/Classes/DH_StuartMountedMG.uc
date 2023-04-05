//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StuartMountedMG extends DH_ShermanMountedMG;

defaultproperties
{
    MaxPositiveYaw=3500
    NumMGMags=7
    FireEffectOffset=(X=-30.0,Y=0.0,Z=25.0) // positions fire on co-driver's hatch
    WeaponAttachOffset=(X=2.0,Y=0.0,Z=0.0) // this is for M5 Stuart (as the MG mesh is off-kilter when not adjusted
}
