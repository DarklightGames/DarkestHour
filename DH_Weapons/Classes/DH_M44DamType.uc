//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M44DamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
    WeaponClass=Class'DH_Weapons.DH_M44Weapon'
    DeathString="%o was killed by %k's M44."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.000000
    PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
    KDamageImpulse=2250.000000
}
