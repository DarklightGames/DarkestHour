//=============================================================================
// DH_PIATBashDamType
//=============================================================================

class DH_PIATBashDamType extends ROWeaponBashDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'DH_ATWeapons.DH_PIATWeapon'
     DeathString="%o was smacked with %k's PIAT."
     FemaleSuicide="%o turned the PIAT on herself."
     MaleSuicide="%o turned the PIAT on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
