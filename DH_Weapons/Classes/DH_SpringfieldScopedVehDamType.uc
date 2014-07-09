//=============================================================================
// DH_SpringfieldScopedVehDamType
//=============================================================================

class DH_SpringfieldScopedVehDamType extends ROVehicleDamageType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt2_tex.deathicons.sniperkill'
     WeaponClass=Class'DH_Weapons.DH_SpringfieldScopedWeapon'
     DeathString="%o was sniped by %k's M1903 Springfield scoped."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     KDamageImpulse=200.000000
}
