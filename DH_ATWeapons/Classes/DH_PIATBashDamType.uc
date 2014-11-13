//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PIATBashDamType extends ROWeaponBashDamageType
    abstract;

defaultproperties
{
     WeaponClass=class'DH_ATWeapons.DH_PIATWeapon'
     DeathString="%o was smacked with %k's PIAT."
     FemaleSuicide="%o turned the PIAT on herself."
     MaleSuicide="%o turned the PIAT on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
