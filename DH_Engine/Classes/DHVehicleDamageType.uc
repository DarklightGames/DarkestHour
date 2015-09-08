//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleDamageType extends ROVehicleDamageType
    abstract;

defaultproperties
{
    DeathString="%o was killed by %k's %w"
    MaleSuicide="%o was killed by his own %w"
    FemaleSuicide="%o was killed by her own %w"
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    LowDetailEmitter=class'ROEffects.ROBloodPuffSmall'
    LowGoreDamageEmitter=class'ROEffects.ROBloodPuffNoGore'
    KDamageImpulse=200.0
}
