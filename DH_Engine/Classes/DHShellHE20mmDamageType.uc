//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellHE20mmDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.15
    TreadDamageModifier=0.1 // 0.15 in 234
    VehicleMomentumScaling=0.5 // 0.05 in 234
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180 // 100 in 234
}
