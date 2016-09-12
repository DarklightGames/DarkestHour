//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    TankDamageModifier=0.6
    TreadDamageModifier=0.8
    VehicleDamageModifier=0.75
    APCDamageModifier=0.66
    //compile error  HUDIcon=texture'DH_ROFX_Tex.HUD.rpg43kill'
    WeaponClass=class'DH_Weapons.DH_RPG43GrenadeWeapon'
    DeathString="%o was blown up by %k's RPG-43 grenade."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
}
