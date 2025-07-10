//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShellHEATDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    TankDamageModifier=0.02
    APCDamageModifier=0.4
    VehicleDamageModifier=0.85
    TreadDamageModifier=0.2
    bExtraMomentumZ=false
    VehicleMomentumScaling=1.0
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=400
}
