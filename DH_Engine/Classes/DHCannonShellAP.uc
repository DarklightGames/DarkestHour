//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
