//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

// Matt: this class is deprecated, as functions that used to use HVAPlarge now use RoundType = HVAP and simply lookup the projectile's default ShellDiameter
// But retained as legacy so that classes that extend from here & aren't edited will not break
class DHTankCannonShellHVAP90 extends DHTankCannonShellHVAP
    abstract;

defaultproperties
{
    RoundType=RT_HVAP
    bShatterProne=true
}
