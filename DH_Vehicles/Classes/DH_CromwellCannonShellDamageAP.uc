//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CromwellCannonShellDamageAP extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
    TreadDamageModifier=0.85
    DeathString="%o was killed by %k's Cromwell APC shell."
}
