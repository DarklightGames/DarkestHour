//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_LocustCannonShell extends DH_StuartCannonShell;

defaultproperties
{
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    DrawScale=10.0
    CoronaClass=none
    bHasTracer=false // actually has a tracer but we use a tracer static mesh for the projectile, so no need for extra tracer effect (normally the CoronaClass)
}
