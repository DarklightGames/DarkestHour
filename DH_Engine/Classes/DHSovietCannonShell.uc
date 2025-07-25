//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSovietCannonShell extends DHCannonShellAP // a solid shot armor-piercing shell (with no armor-piercing cap or ballistic cap)
    abstract;                                     // for Soviet APBC shells (with ballistic cap), specify RoundType=RT_APBC in defaultproperties

defaultproperties
{
    bDebugInImperial=false
    CoronaClass=Class'DHShellTracer_GreenLarge'
    ShellTrailClass=Class'DHShellTrail_Green'
    TracerHue=64
}
