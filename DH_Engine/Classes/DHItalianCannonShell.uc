//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHItalianCannonShell extends DHCannonShell
    abstract;

defaultproperties
{
    bDebugInImperial=false
    // TODO: replace these with white effects
    CoronaClass=class'DH_Effects.DHShellTracer_OrangeLarge'
    ShellTrailClass=class'DH_Effects.DHShellTrail_YellowOrange'
    TracerHue=40
}
