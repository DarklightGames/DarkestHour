//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPD40BashDamType extends DHWeaponBashDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_Weapons.DH_PPD40Weapon'
    DeathString="%o was smacked with %k's PPD40."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.000000
    KDamageImpulse=400.000000
}
