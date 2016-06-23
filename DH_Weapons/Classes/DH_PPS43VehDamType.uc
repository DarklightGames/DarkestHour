//=============================================================================
// PPS43VehDamType
//=============================================================================
// Vehicle Damage type
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_PPS43VehDamType extends ROVehicleDamageType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
	 HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
	 WeaponClass=Class'ROInventory.PPS43Weapon'
	 DeathString="%o was killed by %k's PPS43."
	 FemaleSuicide="%o turned the gun on herself."
	 MaleSuicide="%o turned the gun on himself."
	 GibModifier=0.000000
	 PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
	 KDamageImpulse=200.000000
}
