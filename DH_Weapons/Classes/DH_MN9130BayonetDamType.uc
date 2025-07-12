//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MN9130BayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_MN9130Weapon'
    GibModifier=0.0
    KDamageImpulse=400
    PawnDamageEmitter=Class'ROBloodPuff'
}
