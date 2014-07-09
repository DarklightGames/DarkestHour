//=============================================================================
// DH_USSmokeGrenadeDamType
//=============================================================================

class DH_USSmokeGrenadeDamType extends ROGrenadeDamType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.germgrenade'
     WeaponClass=Class'DH_Equipment.DH_USSmokeGrenadeWeapon'
     DeathString="%o was burned up by %k's M15 Smoke Grenade."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
