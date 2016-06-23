//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130ScopedBashDamType extends DHWeaponBashDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    DeathString="%o was smacked with %k's MN 91/30 scoped."
    MaleSuicide="%o turned the gun on himself."
    FemaleSuicide="%o turned the gun on herself."

    WeaponClass=class'DH_Weapons.DH_MN9130ScopedWeapon'

    GibModifier=0.0
    KDamageImpulse=400
}

