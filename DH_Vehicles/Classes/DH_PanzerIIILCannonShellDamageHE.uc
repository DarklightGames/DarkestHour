//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIIILCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.5
    DeathString="%o was ripped apart by shrapnel from %k's Panzer III Ausf.L HE shell."
    bArmorStops=true
    KDamageImpulse=3000.0
    VehicleMomentumScaling=1.1
    HumanObliterationThreshhold=180
}
