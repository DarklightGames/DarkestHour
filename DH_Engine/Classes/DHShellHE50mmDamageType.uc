//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShellHE50mmDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    TreadDamageModifier=0.2
    VehicleMomentumScaling=1.1
    KDamageImpulse=3000.0
    KDeathVel=250.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
}
