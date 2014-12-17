//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PIATImpactDamType extends RORocketImpactDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.piatkill'
    WeaponClass=class'DH_ATWeapons.DH_PIATWeapon'
    DeathString="%o was killed by %k's PIAT."
    FemaleSuicide="%o was careless with her PIAT."
    MaleSuicide="%o was careless with his PIAT."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.000000
}
