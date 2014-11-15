//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kar98ScopedBashDamType extends ROWeaponBashDamageType
    abstract;

defaultproperties
{
     WeaponClass=class'DH_Weapons.DH_Kar98ScopedWeapon'
     DeathString="%o was killed by %k's Karabiner 98k."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
