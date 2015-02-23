//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_VehicleCrushedDamType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.mine'
    APCDamageModifier=1.0
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.75
    bCauseViewJarring=true
    DeathString="%o was crushed by %k's tank."
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
}
