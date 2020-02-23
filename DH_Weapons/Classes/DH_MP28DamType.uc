//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MP28DamType extends DHSmallCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_MP28Weapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b9mm'
    KDamageImpulse=1000.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
