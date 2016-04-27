//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_P38DamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.b9mm'
    WeaponClass=class'DH_Weapons.DH_P38Weapon'
    KDamageImpulse=750.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
