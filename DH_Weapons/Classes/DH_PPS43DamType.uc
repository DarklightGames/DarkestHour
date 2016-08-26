//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPS43DamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
    WeaponClass=class'DH_Weapons.DH_PPS43Weapon'
    DeathString="%o was killed by %k's PPS43."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.000000
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=1000.000000
    KDeathVel=100.000000
    KDeathUpKick=0.000000
}
