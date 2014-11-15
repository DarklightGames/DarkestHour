//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerFaustImpactDamType extends RORocketImpactDamage
    abstract;

defaultproperties
{
     HUDIcon=Texture'InterfaceArt2_tex.deathicons.faustkill'
     WeaponClass=class'DH_ATWeapons.DH_PanzerFaustWeapon'
     DeathString="%o was killed by %k's Panzerfaust."
     FemaleSuicide="%o was careless with her Panzerfaust."
     MaleSuicide="%o was careless with his Panzerfaust."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
     HumanObliterationThreshhold=400
}
