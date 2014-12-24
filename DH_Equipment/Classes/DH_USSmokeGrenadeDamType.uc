//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSmokeGrenadeDamType extends DHGrenadeDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.weapon_icons.usgrenade'
    WeaponClass=class'DH_Equipment.DH_USSmokeGrenadeWeapon'
    DeathString="%o was burned up by %k's %w."
}
