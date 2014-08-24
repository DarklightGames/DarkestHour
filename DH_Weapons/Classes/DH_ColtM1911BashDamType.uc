//=============================================================================
// DH_ColtM1911BashDamType
//=============================================================================

class DH_ColtM1911BashDamType extends ROWeaponBashDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WeaponClass=Class'DH_Weapons.DH_ColtM1911Weapon'
     DeathString="%o was smacked by %k's Colt M1911."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
