//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM91BayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_CarcanoM91Weapon'
    GibModifier=0.0
    KDamageImpulse=400
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
}
