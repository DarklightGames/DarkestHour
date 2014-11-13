//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kar98BayonetDamType extends ROWeaponBayonetDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WeaponClass=Class'DH_Weapons.DH_Kar98Weapon'
     DeathString="%o was stabbed by %k's mounted bayonet."
     FemaleSuicide="%o turned the bayonet on herself."
     MaleSuicide="%o turned the bayonet on himself."
     GibModifier=0.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
