//=============================================================================
// DH_BazookaBashDamType
//=============================================================================

class DH_BazookaBashDamType extends ROWeaponBashDamageType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WeaponClass=Class'DH_ATWeapons.DH_BazookaWeapon'
     DeathString="%o was smacked with %k's Bazooka."
     FemaleSuicide="%o turned the rocket on herself."
     MaleSuicide="%o turned the rocket on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
