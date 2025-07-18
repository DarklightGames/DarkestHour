//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M44BayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_M44Weapon'
    GibModifier=0.0
    PawnDamageEmitter=Class'ROBloodPuff'
    KDamageImpulse=400.0
}
