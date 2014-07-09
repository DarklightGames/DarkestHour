//=============================================================================
// DH_PanzerschreckBashDamType
//=============================================================================

class DH_PanzerschreckBashDamType extends ROWeaponBashDamageType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WeaponClass=Class'DH_ATWeapons.DH_PanzerschreckWeapon'
     DeathString="%o was smacked with %k's Panzerschreck."
     FemaleSuicide="%o turned the rocket on herself."
     MaleSuicide="%o turned the rocket on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
