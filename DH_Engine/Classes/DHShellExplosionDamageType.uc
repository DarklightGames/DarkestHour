//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShellExplosionDamageType extends ROTankShellExplosionDamage
    abstract;

var bool bIsArtilleryExplosion;

defaultproperties
{
    bIsArtilleryExplosion=false
    VehicleMomentumScaling=1.3
    KDamageImpulse=5000.0
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=265
}
