//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIIILCannonShellDamageAP extends DHTankShellImpactDamage
    abstract;

//Damage class for shells in the 37mm to 50mm calibers

defaultproperties
{
    APCDamageModifier=0.75
    VehicleDamageModifier=0.85
    TreadDamageModifier=0.75
    DeathString="%o was killed by %k's Panzer III Ausf.L APC shell."
}
