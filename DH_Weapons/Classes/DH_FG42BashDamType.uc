//=============================================================================
// DH_FG42BashDamType
//=============================================================================

class DH_FG42BashDamType extends ROWeaponBashDamageType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WeaponClass=Class'DH_Weapons.DH_FG42Weapon'
     DeathString="%o was smacked by %k's Fallschirmjägergewehr 42."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
