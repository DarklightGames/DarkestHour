//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PTRDDamType extends DHLargeCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_PTRDWeapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'

    TankDamageModifier=0.09
    APCDamageModifier=0.13
    VehicleDamageModifier=0.13
    TreadDamageModifier=0.08

    PawnDamageEmitter=class'DH_Effects.DHBloodPuffLargeCaliber'
    bThrowRagdoll=true
    GibModifier=4.0
    GibPerterbation=0.15
    KDamageImpulse=4500.0
    KDeathVel=200.0
    KDeathUpKick=25.0
    VehicleMomentumScaling=0.05
}
