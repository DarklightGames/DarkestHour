//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40ScopedDamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    DeathString="%o was sniped by %k's SVT-40."
    MaleSuicide="%o turned the gun on himself."
    FemaleSuicide="%o turned the gun on herself."
    WeaponClass=class'SVT40ScopedWeapon'
    GibModifier=0.0
    KDeathVel=115.0
    KDamageImpulse=2500.0
    KDeathUpKick=5.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    HUDIcon=texture'InterfaceArt_tex.deathicons.b762mm'
}
