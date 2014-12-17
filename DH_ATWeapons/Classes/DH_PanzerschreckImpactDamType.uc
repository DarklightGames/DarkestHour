//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerschreckImpactDamType extends RORocketImpactDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.schreckkill'
    WeaponClass=class'DH_ATWeapons.DH_PanzerschreckWeapon'
    DeathString="%o was killed by %k's Panzerschreck."
    FemaleSuicide="%o was careless with her Panzerschreck."
    MaleSuicide="%o was careless with his Panzerschreck."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.000000
}
