//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sherman105ShellImpactDamageHEAT extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    APCDamageModifier=0.75
    DeathString="%o was killed by %k's Sherman(105) HEAT shell."
    bArmorStops=true
}
