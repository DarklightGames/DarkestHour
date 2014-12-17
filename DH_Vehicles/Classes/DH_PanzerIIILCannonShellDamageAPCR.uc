//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIIILCannonShellDamageAPCR extends DHTankShellImpactDamage
    abstract;

//Damage class for shells in the 37mm to 50mm calibers

defaultproperties
{
    APCDamageModifier=0.650000
    VehicleDamageModifier=0.850000
    TreadDamageModifier=0.750000
    DeathString="%o was killed by %k's Panzer III Ausf.L APCR shell."
}
