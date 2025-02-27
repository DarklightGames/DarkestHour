//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponBayonetDamageType extends ROWeaponBayonetDamageType
    abstract;

defaultproperties
{
    VehicleDamageModifier=0.0
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=400.0
    HumanObliterationThreshhold=1000001
}
