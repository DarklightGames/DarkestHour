//=============================================================================
// DH_OrangeSmokeDamType
//=============================================================================

class DH_OrangeSmokeDamType extends ROGrenadeDamType
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.germgrenade'
     WeaponClass=Class'DH_Equipment.DH_OrangeSmokeWeapon'
     DeathString="%o was burned up by %k's RauchSichtzeichen Orange 160."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
