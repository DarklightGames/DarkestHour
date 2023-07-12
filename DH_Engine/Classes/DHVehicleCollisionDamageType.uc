//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleCollisionDamageType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.mine'
    APCDamageModifier=0.2
    VehicleDamageModifier=0.5
    TreadDamageModifier=0.75
    bCauseViewJarring=true
    DeathString="%o was killed in a crash with %k's vehicle."
    MaleSuicide="%o was killed in a vehicle crash."
    FemaleSuicide="%o was killed in a vehicle crash."
    bLocationalHit=false
    bDetonatesGoop=true
    bDelayedDamage=true
    bCausedByWorld=true
    KDamageImpulse=2000.0
    KDeathVel=120.0
    KDeathUpKick=30.0
    KDeadLinZVelScale=0.005
    KDeadAngVelScale=0.0036
}
