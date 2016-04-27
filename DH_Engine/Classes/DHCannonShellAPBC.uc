//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// Base class for APBC armor-piercing shells
// (with ballistic cap but no armor-piercing cap)
//==============================================================================

class DHCannonShellAPBC extends DHCannonShell
    abstract;

defaultproperties
{
    RoundType=RT_APBC
    bShatterProne=true
}
