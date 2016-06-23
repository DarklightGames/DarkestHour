//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130ScopedDamType extends DHWeaponProjectileDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    DeathString="%o was sniped by %k's MN 91/30 scoped."
    MaleSuicide="%o turned the gun on himself."
    FemaleSuicide="%o turned the gun on herself."

    WeaponClass=class'DH_Weapons.DH_MN9130ScopedWeapon'

    GibModifier=0.0
    KDeathVel=115.000000
    KDamageImpulse=2500
    KDeathUpKick=5

    PawnDamageEmitter=class'ROEffects.ROBloodPuff'

    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
}