//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuH42CannonShellDamageHEAT extends DHCannonShellDamageHEAT
    abstract;

defaultproperties
{
    APCDamageModifier=0.65 // Matt: add this to match Sherman 105, instead of default 0.4
    DeathString="%o was burnt up by %k's StuH42 HEAT shell."
}
