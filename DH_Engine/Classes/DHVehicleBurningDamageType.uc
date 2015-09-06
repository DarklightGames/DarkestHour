//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleBurningDamageType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.VehicleFireKill'
    TankDamageModifier=1.0
    APCDamageModifier=1.0
    VehicleDamageModifier=1.0
    DeathString="%o was burned up in a vehicle fire that %k started."
    MaleSuicide="%o burned up in a vehicle fire."
    FemaleSuicide="%o burned up in a vehicle fire."
    bLocationalHit=false
    bDetonatesGoop=true
    bDelayedDamage=true
    GibModifier=10.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuffLarge'
    KDamageImpulse=3000.0
    KDeathVel=200.0
    KDeathUpKick=300.0
}
