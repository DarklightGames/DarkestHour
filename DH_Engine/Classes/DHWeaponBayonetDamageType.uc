//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponBayonetDamageType extends ROWeaponBayonetDamageType
    abstract;

defaultproperties
{
    VehicleDamageModifier=0.0
    DeathString="%o was skewered on %k's %w bayonet."
    MaleSuicide="%o skewered himself on his own %w bayonet."
    FemaleSuicide="%o skewered herself on her own %w bayonet."
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=400.0
    HumanObliterationThreshhold=1000001
}
