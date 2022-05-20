//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MP38DamType extends DHSmallCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_MP38Weapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b9mm'
    KDamageImpulse=1000.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
