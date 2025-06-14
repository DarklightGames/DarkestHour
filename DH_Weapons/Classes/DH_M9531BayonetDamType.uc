//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M9531BayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_M9531Weapon'
    GibModifier=0.0
    KDamageImpulse=400
    PawnDamageEmitter=Class'ROBloodPuff'
}
