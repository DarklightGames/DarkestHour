//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_STG44DamType extends DHMediumCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_STG44Weapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b792mm'
    KDamageImpulse=1500.0
    KDeathVel=110.0
    KDeathUpKick=2.0
}
