//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RPG43GrenadeDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_RPG43GrenadeWeapon'
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.rpg43kill'

    VehicleDamageModifier=1.0
    APCDamageModifier=0.75
    TankDamageModifier=0.1
    TreadDamageModifier=0.85
}
