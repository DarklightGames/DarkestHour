//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

// Matt: this class is deprecated, as functions that used to use HVAPlarge now use RoundType = HVAP and simply lookup the projectile's default ShellDiameter
// But retained as legacy so that classes that extend from here & aren't edited will not break
class DH_ROTankCannonShellHVAP90 extends DH_ROTankCannonShellHVAP; // originally extended DH_ROTankCannonShell


defaultproperties
{
    RoundType=RT_HVAP
    bShatterProne=true
}
