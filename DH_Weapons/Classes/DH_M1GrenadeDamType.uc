//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1GrenadeDamType extends DHGrenadeDamageType
    abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.weapon_icons.usgrenade'
     WeaponClass=class'DH_Weapons.DH_M1GrenadeWeapon'
     DeathString="%o was blown up by %k's %w."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
