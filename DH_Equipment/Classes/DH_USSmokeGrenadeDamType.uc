//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSmokeGrenadeDamType extends ROGrenadeDamType
    abstract;

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.germgrenade'
     WeaponClass=class'DH_Equipment.DH_USSmokeGrenadeWeapon'
     DeathString="%o was burned up by %k's M15 Smoke Grenade."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
