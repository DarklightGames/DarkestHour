//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreyhoundCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.5
    DeathString="%o was ripped by shrapnel from %k's Greyhound HE shell."
    bArmorStops=true
    KDamageImpulse=3000.0
    VehicleMomentumScaling=1.1
    HumanObliterationThreshhold=180
}
