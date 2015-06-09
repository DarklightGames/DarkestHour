//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Cromwell6PdrCannonShellDamageAP extends DHCannonShellDamageImpact
    abstract;

defaultproperties
{
    APCDamageModifier=0.75
    TreadDamageModifier=0.85
    DeathString="%o was killed by %k's Cromwell 6 Pounder APC shell."
    FemaleSuicide="%o fired her Cromwell 6 Pounder shell APC prematurely."
    MaleSuicide="%o fired his Cromwell 6 Pounder shell APC prematurely."
}
