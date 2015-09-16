//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdtigerCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.15
    APCDamageModifier=0.5
    VehicleDamageModifier=2.0
    TreadDamageModifier=1.0
    KDamageImpulse=6000.0
    KDeathVel=300.0
    KDeathUpKick=60.0
    HumanObliterationThreshhold=500
}
