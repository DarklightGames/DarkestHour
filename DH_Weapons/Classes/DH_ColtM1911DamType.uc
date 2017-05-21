//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ColtM1911DamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_ColtM1911Weapon'
    HUDIcon=texture'InterfaceArt_tex.deathicons.b762mm'
    KDamageImpulse=750.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
