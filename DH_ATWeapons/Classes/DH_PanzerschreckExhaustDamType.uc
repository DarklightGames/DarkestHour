//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerschreckExhaustDamType extends ROGrenadeDamType
    abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.backblastkill'
     bCauseViewJarring=true
     WeaponClass=class'DH_ATWeapons.DH_PanzerschreckWeapon'
     DeathString="%o was cooked by the exhaust from %k's Panzerschreck."
     FemaleSuicide="%o was cooked by the exhaust from her own Panzerschreck."
     MaleSuicide="%o was cooked by the exhaust from his own Panzerschreck."
     GibModifier=0.000000
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
     KDeathVel=20.000000
}
