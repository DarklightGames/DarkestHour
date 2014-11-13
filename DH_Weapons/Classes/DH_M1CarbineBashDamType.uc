//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1CarbineBashDamType extends ROWeaponBashDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WeaponClass=Class'DH_Weapons.DH_M1CarbineWeapon'
     DeathString="%o was smacked with %k's M1 Carbine."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
