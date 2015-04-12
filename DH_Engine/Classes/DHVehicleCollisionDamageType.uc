//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleCollisionDamageType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.mine'
    APCDamageModifier=0.2
    VehicleDamageModifier=0.5
    TreadDamageModifier=0.75
    bCauseViewJarring=true
    DeathString="%o collided with %k's vehicle."
    FemaleSuicide="%o was killed in a vehicle crash."
    MaleSuicide="%o was killed in a vehicle crash."
    bLocationalHit=false
    bDetonatesGoop=true
    bDelayedDamage=true
    bCausedByWorld=true
    KDamageImpulse=2000.0
    KDeathVel=120.0
    KDeathUpKick=30.0
    KDeadLinZVelScale=0.005
    KDeadAngVelScale=0.0036
}a
