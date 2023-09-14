//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Base class for solid shot armor-piercing shells
// (with no armor-piercing cap or ballistic cap)
//==============================================================================

class DHCannonShellAP extends DHCannonShell
    abstract;

defaultproperties
{
    RoundType=RT_AP
    bShatterProne=true
}
