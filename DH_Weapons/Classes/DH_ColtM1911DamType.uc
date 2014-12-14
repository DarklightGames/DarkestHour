//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ColtM1911DamType extends ROWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
    WeaponClass=class'DH_Weapons.DH_ColtM1911Weapon'
    DeathString="%o was killed by %k's Colt M1911."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.000000
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=750.000000
    KDeathVel=100.000000
    KDeathUpKick=0.000000
}
