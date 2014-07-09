//=============================================================================
// DH_EnfieldNo4ScopedVehDamType
//=============================================================================

class DH_EnfieldNo4ScopedVehDamType extends ROVehicleDamageType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt2_tex.deathicons.sniperkill'
     WeaponClass=Class'DH_Weapons.DH_EnfieldNo4ScopedWeapon'
     DeathString="%o was sniped by %k's scoped Enfield No.4."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     KDamageImpulse=200.000000
}
