//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHSovietCannonShell extends DHCannonShellAP // a solid shot armor-piercing shell (with no armor-piercing cap or ballistic cap)
    abstract;                                     // for Soviet APBC shells (with ballistic cap), specify RoundType=RT_APBC in defaultproperties

defaultproperties
{
    CoronaClass=class'DH_Effects.DHShellTracer_GreenLarge'
    StaticMesh=StaticMesh'DH_Tracers.shells.Soviet_shell'
    bDebugInImperial=false
}
