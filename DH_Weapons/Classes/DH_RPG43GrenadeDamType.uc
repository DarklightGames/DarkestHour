//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_RPG43GrenadeWeapon'
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.rpg43kill'
    VehicleDamageModifier=0.75
    APCDamageModifier=0.66
    TankDamageModifier=0.6
    TreadDamageModifier=0.8
}
