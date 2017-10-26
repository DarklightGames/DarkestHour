//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHVehicleDamageType extends ROVehicleDamageType
    abstract;

defaultproperties
{
    // Zeroed APCDamageModifier so small arms guns don't cause damage to APCs or anti-tank guns (which use the APC modifier)
    // Previously APCs or AT guns relied on a minimum APCDamageModifier threshold in the TakeDamage() function, preventing damage by bullets
    // But it's much cleaner simply to give bullets a zero APCDamageModifier (& override if required for more powerful bullets, e.g. armour piercing bullets)
    APCDamageModifier=0.0

    DeathString="%o was killed by %k's %w."
    MaleSuicide="%o was killed by his own %w."
    FemaleSuicide="%o was killed by her own %w."
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    LowDetailEmitter=class'ROEffects.ROBloodPuffSmall'
    LowGoreDamageEmitter=class'ROEffects.ROBloodPuffNoGore'
    KDamageImpulse=200.0
}
