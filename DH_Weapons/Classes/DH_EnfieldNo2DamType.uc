//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_EnfieldNo2DamType extends DHSmallCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_EnfieldNo2Weapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
    KDamageImpulse=750.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
