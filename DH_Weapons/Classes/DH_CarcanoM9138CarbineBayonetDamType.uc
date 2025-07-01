//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM9138CarbineBayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_Weapons.DH_CarcanoM9138CarbineWeapon'
    GibModifier=0.0
    KDamageImpulse=400
    PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
}
