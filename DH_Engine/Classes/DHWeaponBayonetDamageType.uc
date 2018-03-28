//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHWeaponBayonetDamageType extends DHMeleeWeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was skewered on %k's %w bayonet."
    MaleSuicide="%o skewered himself on his own %w bayonet."
    FemaleSuicide="%o skewered herself on her own %w bayonet."

    HUDIcon=Texture'InterfaceArt_tex.deathicons.knife'
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'

    KDamageImpulse=1000
    KDeathUpKick=10
}
