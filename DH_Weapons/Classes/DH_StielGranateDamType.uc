//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StielGranateDamType extends DHGrenadeDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.germgrenade'
    WeaponClass=class'DH_Weapons.DH_StielGranateWeapon'
    DeathString="%o was blown up by %k's %w."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.000000
}
