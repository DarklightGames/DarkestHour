//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellHE105mmDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    TankDamageModifier=0.2 //increased from the standard 0.05
    TreadDamageModifier=0.5
    VehicleMomentumScaling=1.7
    KDamageImpulse=7000.0
    HumanObliterationThreshhold=500
}
