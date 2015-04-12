//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHHECannonShellDamageSmoke extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.75
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.5
    bArmorStops=true
    bLocationalHit=true
    KDamageImpulse=3000.0
    VehicleMomentumScaling=1.1
    HumanObliterationThreshhold=180
}
