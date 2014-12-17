//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_OrangeSmokeDamType extends DHGrenadeDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.germgrenade'
    WeaponClass=class'DH_Equipment.DH_OrangeSmokeWeapon'
    DeathString="%o was burned up by %k's %w."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.000000
}
