//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIIINCannonShellDamageHEAT extends DH_HEATCannonShellDamage
    abstract;

defaultproperties
{
    //  APCDamageModifier=0.65 // Matt: removed so uses default 0.4, same as panzer IV
    DeathString="%o was burnt up by %k's Panzer III HEAT shell."
}
