//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MN9130BayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_MN9130Weapon'
    GibModifier=0.0
    KDamageImpulse=400
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
}
