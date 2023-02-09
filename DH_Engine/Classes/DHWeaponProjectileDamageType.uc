//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponProjectileDamageType extends ROWeaponProjectileDamageType
    abstract;

defaultproperties
{
    // Because bullet classes previously used a separate MyVehicleDamage for hits on vehicles (based on ROVehicleDamageType class)
    // But it is now deprecated as unnecessary & instead bullets simply use their normal MyDamageType (based on ROWeaponDamageType class)
    // So to maintain the same damage modifiers for damage to vehicles, we need to use the same modifiers of the deprecated ROVehicleDamageType class
    // But we do not use ROVehicleDamageType's APCDamageModifier (0.025) as we don't want bullets to damage APCs or anti-tank guns (which use the APC modifier)
    // Previously APCs or AT guns relied on a minimum APCDamageModifier threshold in the TakeDamage() function, preventing damage by bullets
    // But it's much cleaner simply to give bullets a zero APCDamageModifier (& override if required for more powerful bullets, e.g. armour piercing bullets)
    VehicleDamageModifier=0.1

    DeathString="%o was killed by %k's %w."
    MaleSuicide="%o was killed by his own %w."
    FemaleSuicide="%o was killed by her own %w."
    KDamageImpulse=2250.0 // default for full power rifle ammo
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
}
