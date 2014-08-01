//=============================================================================
// DH_PanzerfaustExhaustDamType
//=============================================================================
class DH_PanzerfaustExhaustDamType extends ROGrenadeDamType
	abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.backblastkill'
     bCauseViewJarring=true
     WeaponClass=Class'DH_ATWeapons.DH_PanzerFaustWeapon'
     DeathString="%o was cooked by the exhaust from %k's Panzerfaust."
     FemaleSuicide="%o was cooked by the exhaust from her own Panzerfaust."
     MaleSuicide="%o was cooked by the exhaust from his own Panzerfaust."
     GibModifier=0.000000
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
     KDeathVel=20.000000
}
