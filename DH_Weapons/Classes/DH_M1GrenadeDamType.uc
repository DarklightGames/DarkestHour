//=============================================================================
// DH_M1GrenadeDamType
//=============================================================================

class DH_M1GrenadeDamType extends ROGrenadeDamType
    abstract;

//=============================================================================
// defaultproperties  `quit
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.weapon_icons.usgrenade'
     WeaponClass=Class'DH_Weapons.DH_M1GrenadeWeapon'
     DeathString="%o was blown up by %k's Mk II grenade."
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
}
