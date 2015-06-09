//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanCannonShellDamageAP extends DHCannonShellDamageImpact
    abstract;

defaultproperties
{
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
    TreadDamageModifier=0.85
    DeathString="%o was killed by %k's Sherman 75mm APC shell."
}
