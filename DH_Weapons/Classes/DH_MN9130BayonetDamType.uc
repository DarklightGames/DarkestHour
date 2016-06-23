//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130BayonetDamType extends DHWeaponBayonetDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    DeathString="%o was stabbed by %k's mounted bayonet."
    MaleSuicide="%o turned the bayonet on himself."
    FemaleSuicide="%o turned the bayonet on herself."

    WeaponClass=class'DH_Weapons.DH_MN9130Weapon'

    GibModifier=0.0
    KDamageImpulse=400

    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
}
