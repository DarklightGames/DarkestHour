//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_OrangeSmokeDamType extends ROGrenadeDamType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.germgrenade'
     WeaponClass=class'DH_Equipment.DH_OrangeSmokeWeapon'
     DeathString="%o was burned up by %k's RauchSichtzeichen Orange 160."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
