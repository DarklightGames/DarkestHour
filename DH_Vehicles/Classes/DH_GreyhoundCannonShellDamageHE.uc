//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GreyhoundCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.5
    DeathString="%o was ripped apart by shrapnel from %k's Greyhound HE shell."
    KDamageImpulse=3000.0
    VehicleMomentumScaling=1.1
    HumanObliterationThreshhold=180
}
