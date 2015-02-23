//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIVCannonShellImpactDamageHEAT extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    APCDamageModifier=0.65
    TreadDamageModifier=0.75
    DeathString="%o was killed by %k's Panzer IV HEAT shell."
    bArmorStops=true // Matt: added so side skirts stop HEAT round
}
