//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM38CavalryBayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_Weapons.DH_CarcanoM38CavalryWeapon'
    GibModifier=0.0
    KDamageImpulse=400
    PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
}
