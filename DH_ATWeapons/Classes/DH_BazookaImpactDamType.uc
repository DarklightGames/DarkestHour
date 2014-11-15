//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BazookaImpactDamType extends RORocketImpactDamage
    abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.zookakill'
     WeaponClass=class'DH_ATWeapons.DH_BazookaWeapon'
     DeathString="%o was killed by %k's Bazooka."
     FemaleSuicide="%o was careless with her Bazooka."
     MaleSuicide="%o was careless with his Bazooka."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
