//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz2341CannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.15
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.15
    DeathString="%o was blown apart by %k's Sd.Kfz.234/1 HE round."
    VehicleMomentumScaling=0.05
    HumanObliterationThreshhold=100
}
