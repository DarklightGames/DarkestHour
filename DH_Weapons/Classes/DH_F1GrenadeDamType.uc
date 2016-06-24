//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadeDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.rusgrenade'
    WeaponClass=Class'DH_Weapons.DH_F1GrenadeWeapon'
    DeathString="%o was blown up by %k's F1 grenade."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.000000
}
