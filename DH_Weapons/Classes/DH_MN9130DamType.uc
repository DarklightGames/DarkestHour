//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130DamType extends DHWeaponProjectileDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    DeathString="%o was killed by %k's MN 91/30."
    MaleSuicide="%o turned the gun on himself."
    FemaleSuicide="%o turned the gun on herself."

    WeaponClass=class'DH_Weapons.DH_MN9130Weapon'

    GibModifier=0.0
    KDeathVel=115.000000
    KDamageImpulse=2250
    KDeathUpKick=5

    PawnDamageEmitter=class'ROEffects.ROBloodPuff'

    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
}