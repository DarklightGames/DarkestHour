//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_M9530BayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_M9530Weapon'
    GibModifier=0.0
    KDamageImpulse=400
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
}
