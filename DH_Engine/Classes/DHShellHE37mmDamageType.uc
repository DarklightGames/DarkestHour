//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShellHE37mmDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    TreadDamageModifier=0.15
    VehicleMomentumScaling=1.0
    KDamageImpulse=2000.0
    KDeathVel=250.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
}
