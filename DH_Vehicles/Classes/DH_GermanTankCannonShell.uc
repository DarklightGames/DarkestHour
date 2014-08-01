//==============================================================================
// DH_GermanTankCannonShell
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for all German tank cannon APCBC shells
//==============================================================================
class DH_GermanTankCannonShell extends DH_ROTankCannonShell;

defaultproperties
{
     bIsAlliedShell=false
     TracerEffect=Class'DH_Effects.DH_OrangeTankShellTracerBig'
     StaticMesh=StaticMesh'DH_Tracers.shells.German_shell'
}
