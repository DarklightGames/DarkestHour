//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSovietCannonShell extends DHCannonShellAP // a solid shot armor-piercing shell (with no armor-piercing cap or ballistic cap)
    abstract;                                     // for Soviet APBC shells (with ballistic cap), specify RoundType=RT_APBC in defaultproperties

defaultproperties
{
    bDebugInImperial=false
    CoronaClass=class'DH_Effects.DHShellTracer_GreenLarge'
    ShellTrailClass=class'DH_Effects.DHShellTrail_Green'
    TracerHue=64
}
