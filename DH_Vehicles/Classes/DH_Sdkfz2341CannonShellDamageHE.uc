//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2341CannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.15
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.15
    DeathString="%o was ripped by shrapnel from %k's Sdkfz 234/2 HE shell."
    bArmorStops=true
    VehicleMomentumScaling=0.05
    HumanObliterationThreshhold=100
}
