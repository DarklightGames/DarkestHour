//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellAPExplosionDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.05
    VehicleDamageModifier=0.25
    TreadDamageModifier=0.05
    VehicleMomentumScaling=1.0
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
}
