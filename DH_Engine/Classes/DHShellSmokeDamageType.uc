//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHShellSmokeDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.25
    VehicleDamageModifier=0.5
    TreadDamageModifier=0.25
    VehicleMomentumScaling=1.0
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
}
