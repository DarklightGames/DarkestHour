//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GermanTankCannonShell extends DHTankCannonShell
    abstract;

defaultproperties
{
    bIsAlliedShell=false
    TracerEffect=class'DH_Effects.DH_OrangeTankShellTracerBig'
    StaticMesh=StaticMesh'DH_Tracers.shells.German_shell'
}
