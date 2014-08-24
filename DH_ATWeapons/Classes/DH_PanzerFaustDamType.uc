//=============================================================================
// PanzerFaustDamType
//=============================================================================
// Damage type
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2006 John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_PanzerFaustDamType extends ROAntiTankProjectileDamType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt2_tex.deathicons.faustkill'
     TankDamageModifier=0.030000
     APCDamageModifier=0.250000
     VehicleDamageModifier=0.800000
     TreadDamageModifier=0.250000
     WeaponClass=Class'DH_ATWeapons.DH_PanzerFaustWeapon'
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
     KDeathVel=150.000000
     KDeathUpKick=50.000000
}
