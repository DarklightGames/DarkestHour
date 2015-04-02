//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Base class for APBC armor-piercing shells
// (with ballistic cap but no armor-piercing cap)
//==============================================================================

class DHTankCannonShellAPBC extends DHTankCannonShell
    abstract;

defaultproperties
{
    RoundType=RT_APBC
    bShatterProne=true
}
