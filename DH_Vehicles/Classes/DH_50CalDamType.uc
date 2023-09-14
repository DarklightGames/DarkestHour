//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_50CalDamType extends DHLargeCaliberDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b792mm'
    TankDamageModifier=0.2
    APCDamageModifier=0.3
    VehicleDamageModifier=0.4
    TreadDamageModifier=0.25  // 0.5 in 234/1, 1.0 in PTRD
    WeaponClass=class'DH_Weapons.DH_30calWeapon' // 50 cal is vehicle only & doesn't have a WeaponClass in DH_Weapons - never mind, just use dummy class & 50 cal specific death strings
    DeathString="%o was killed by %k's .50 cal machine gun."
    FemaleSuicide="%o was killed by her own .50 cal machine gun."
    MaleSuicide="%o was killed by his own .50 cal machine gun."
    GibModifier=2.0            // 0 in 30cal, 4 in PTRD
    GibPerterbation=0.09       // weapon default is 0.06, 0.15 in PTRD (but that value is used by explosives, so is too high)
    VehicleMomentumScaling=0.2 // 0.3 in 234/1, 0.6 in PTRD, 1.3 is default for tank cannon
    KDamageImpulse=3000.0      // 2250 in 30cal, 4500 in PTRD
    KDeathVel=175.0            // 115 in 30 cal, 200 in PTRD
    KDeathUpKick=20.0          // 5 in 30 cal, 25 in PTRD
}
