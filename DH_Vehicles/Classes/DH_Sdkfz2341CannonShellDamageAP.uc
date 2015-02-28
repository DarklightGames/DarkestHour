//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz2341CannonShellDamageAP extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.15
    APCDamageModifier=0.35
    VehicleDamageModifier=0.75
    TreadDamageModifier=0.5
    DeathString="%o was killed by %k's Sdkfz 234/1 AP shell."
    VehicleMomentumScaling=0.3
    HumanObliterationThreshhold=75
}
