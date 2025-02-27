//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleBurningDamageType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.VehicleFireKill'
    TankDamageModifier=1.0
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    bLocationalHit=false
    bDetonatesGoop=true
    bDelayedDamage=true
    GibModifier=10.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuffLarge'
    KDamageImpulse=3000.0
    KDeathVel=200.0
    KDeathUpKick=300.0
}
