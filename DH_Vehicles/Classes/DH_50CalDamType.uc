//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_50CalDamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.b792mm'
    TankDamageModifier=0.1
    APCDamageModifier=0.1
    VehicleDamageModifier=0.1
    TreadDamageModifier=0.25
    WeaponClass=class'DH_Weapons.DH_30calWeapon' // 50 cal is only in vehicles, so doesn't have associated WeaponClass in DH_Weapons - nevermind, just add its name to death strings
    DeathString="%o was killed by %k's .50 cal machine gun."
    FemaleSuicide="%o was killed by her own .50 cal machine gun."
    MaleSuicide="%o was killed by his own .50 cal machine gun."
    PawnDamageEmitter=class'ROEffects.ROBloodPuffLarge'
    bAlwaysSevers=true // so limbs & head are severed by a hit from such a powerful bullet
    GibModifier=2.0
    GibPerterbation=0.09
    VehicleMomentumScaling=0.2
    KDamageImpulse=3000.0
    KDeathVel=175.0
    KDeathUpKick=20.0
}
