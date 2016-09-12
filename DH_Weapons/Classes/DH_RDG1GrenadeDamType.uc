//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RDG1GrenadeDamType extends ROGrenadeDamType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.germgrenade'
    WeaponClass=class'DH_Weapons.DH_RDG1GrenadeWeapon'
    DeathString="%o was burned up by %k's smoke grenade."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
}
