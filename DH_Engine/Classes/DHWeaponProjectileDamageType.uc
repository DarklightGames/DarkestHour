//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHWeaponProjectileDamageType extends ROWeaponProjectileDamageType
    abstract;

defaultproperties
{
    DeathString="%o was killed by %k's %w."
    FemaleSuicide="%o was killed by her own %w."
    MaleSuicide="%o was killed by his own %w."
    KDamageImpulse=2250.0 // default for full power rifle ammo
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
}
