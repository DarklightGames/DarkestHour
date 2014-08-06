//=============================================================================
// EA_USSmokeGrenadeDamType
//=============================================================================

class EA_USSmokeGrenadeDamTypeNight extends ROGrenadeDamType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
	 HUDIcon=Texture'InterfaceArt_tex.deathicons.germgrenade'
	 WeaponClass=Class'EA_USSmokeGrenadeWeaponNight'
	 DeathString="%o was burned up by %k's M15 Smoke Grenade."
	 DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
	 DeathOverlayTime=999.000000
}
