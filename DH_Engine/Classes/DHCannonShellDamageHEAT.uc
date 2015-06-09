//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCannonShellDamageHEAT extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.02
    APCDamageModifier=0.4
    VehicleDamageModifier=0.85
    TreadDamageModifier=0.2
    bExtraMomentumZ=false
    KDeathVel=150.0
    HumanObliterationThreshhold=400
}
