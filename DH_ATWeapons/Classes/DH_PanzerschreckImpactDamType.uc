//=============================================================================
// DH_PanzerschreckImpactDamType
//=============================================================================

class DH_PanzerschreckImpactDamType extends RORocketImpactDamage
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.schreckkill'
     WeaponClass=Class'DH_ATWeapons.DH_PanzerschreckWeapon'
     DeathString="%o was killed by %k's Panzerschreck."
     FemaleSuicide="%o was careless with her Panzerschreck."
     MaleSuicide="%o was careless with his Panzerschreck."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
