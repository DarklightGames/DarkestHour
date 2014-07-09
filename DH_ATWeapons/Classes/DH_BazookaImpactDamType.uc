//=============================================================================
// DH_BazookaImpactDamType
//=============================================================================

class DH_BazookaImpactDamType extends RORocketImpactDamage
	abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.zookakill'
     WeaponClass=Class'DH_ATWeapons.DH_BazookaWeapon'
     DeathString="%o was killed by %k's Bazooka."
     FemaleSuicide="%o was careless with her Bazooka."
     MaleSuicide="%o was careless with his Bazooka."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
