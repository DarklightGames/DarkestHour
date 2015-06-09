//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Cromwell6PdrCannonShellDamageAPDS extends DHCannonShellDamageImpact
    abstract;

defaultproperties
{
    APCDamageModifier=0.5
    TreadDamageModifier=0.95
    DeathString="%o was killed by %k's Cromwell 6 Pounder APDS shot."
    FemaleSuicide="%o fired her Cromwell 6 Pounder APDS shot prematurely."
    MaleSuicide="%o fired his Cromwell 6 Pounder APDS shot prematurely."
}
