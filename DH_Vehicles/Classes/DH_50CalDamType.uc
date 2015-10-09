//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_50CalDamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.b792mm'
    TankDamageModifier=0.15 // 0.15 in 234/1, 1.0 in PTRD
    APCDamageModifier=0.25 // 0.35 in 234/1, 0.5 in PTRD
    VehicleDamageModifier=0.25 // 0.75 in 234/1, 0.35 in PTRD, small arms are default 0.1
    TreadDamageModifier=0.25 // 0.5 in 234/1, 1.0 in PTRD
    WeaponClass=class'DH_Weapons.DH_30calWeapon' // 50 cal is vehicle-mounted only, so doesn't have corresponding WeaponClass in DH_Weapons - nevermind, just add its name to death strings below
    DeathString="%o was killed by %k's .50 cal machine gun."
    FemaleSuicide="%o was killed by her own .50 cal machine gun."
    MaleSuicide="%o was killed by his own .50 cal machine gun."
    PawnDamageEmitter=class'ROEffects.ROBloodPuffLarge' // from PTRD, normal is 'ROBloodPuff'
    GibModifier=2.0 // 0 in 30cal, 4 in PTRD
    GibPerterbation=0.09 // weapon default is 0.06, 0.15 in PTRD (but that value is used by explosives, so is too high)
    VehicleMomentumScaling=0.2 // 0.3 in 234/1, 0.6 in PTRD, 1.3 is default for tank cannon
    KDamageImpulse=3000.0 // 2250 in 30cal, 4500 in PTRD
    KDeathVel=175.0 // 115 in 30 cal, 200 in PTRD
    KDeathUpKick=20.0 // 5 in 30 cal, 25 in PTRD
}
