//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleCollisionDamageType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.mine'
    APCDamageModifier=0.2
    VehicleDamageModifier=0.5
    TreadDamageModifier=0.75
    bCauseViewJarring=true
    bLocationalHit=false
    bDetonatesGoop=true
    bDelayedDamage=true
    bCausedByWorld=true
    KDamageImpulse=2000.0
    KDeathVel=120.0
    KDeathUpKick=30.0
    KDeadLinZVelScale=0.005
    KDeadAngVelScale=0.0036
}
