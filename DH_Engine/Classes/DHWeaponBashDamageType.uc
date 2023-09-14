//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponBashDamageType extends ROWeaponBashDamageType
    abstract;

defaultproperties
{
    VehicleDamageModifier=0.0
    DeathString="%o was bludgeoned to death by %k's %w."
    MaleSuicide="%o bludgeoned himself to death with his own %w."
    FemaleSuicide="%o bludgeoned herself to death with her own %w."
    GibModifier=0.0
    KDamageImpulse=400.0
    HumanObliterationThreshhold=1000001
}
