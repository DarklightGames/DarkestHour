//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SatchelDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_SatchelCharge10lb10sWeapon'
    HUDIcon=Texture'InterfaceArt_tex.satchel'

    VehicleDamageModifier=1.0
    APCDamageModifier=1.0
    TankDamageModifier=0.25
    TreadDamageModifier=1.0

    GibModifier=4.0
    KDamageImpulse=5000.0
    KDeathVel=300.0
    KDeathUpKick=75.0
    KDeadLinZVelScale=0.0015
    KDeadAngVelScale=0.0015
    HumanObliterationThreshhold=400
}
