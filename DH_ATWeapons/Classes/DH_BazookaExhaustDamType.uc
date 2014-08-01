//=============================================================================
// DH_BazookaExhaustDamType
//=============================================================================
class DH_BazookaExhaustDamType extends ROGrenadeDamType
	abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.backblastkill'
     bCauseViewJarring=true
     WeaponClass=Class'DH_ATWeapons.DH_BazookaWeapon'
     DeathString="%o was cooked by the exhaust from %k's Bazooka."
     FemaleSuicide="%o was cooked by the exhaust from her own Bazooka."
     MaleSuicide="%o was cooked by the exhaust from his own Bazooka."
     GibModifier=0.000000
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
     KDeathVel=20.000000
}
