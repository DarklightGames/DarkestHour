//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_STG44DamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.b792mm'
    WeaponClass=class'DH_Weapons.DH_STG44Weapon'
    KDamageImpulse=1500.000000
    KDeathVel=110.000000
    KDeathUpKick=2.000000
}
