//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PPSH41DamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_PPSH41Weapon'
    HUDIcon=texture'InterfaceArt_tex.deathicons.b762mm'
    KDamageImpulse=1000.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
