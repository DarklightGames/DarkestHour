//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShellSmokeWPDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.PlayerFireKill'
    bLocationalHit=false
    GibModifier=0.0

    TankDamageModifier=0.0
    VehicleMomentumScaling=1.0
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
}
