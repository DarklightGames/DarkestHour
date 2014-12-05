//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_VehicleCrushedDamType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.mine'
    APCDamageModifier=1.000000
    VehicleDamageModifier=1.000000
    TreadDamageModifier=0.750000
    bCauseViewJarring=true
    DeathString="%o was crushed by %k's tank."
    FemaleSuicide="%o was killed in a vehicle crash."
    MaleSuicide="%o was killed in a vehicle crash."
    bLocationalHit=false
    bDetonatesGoop=true
    bDelayedDamage=true
    bCausedByWorld=true
    KDamageImpulse=2000.000000
    KDeathVel=120.000000
    KDeathUpKick=30.000000
    KDeadLinZVelScale=0.005000
    KDeadAngVelScale=0.003600
}
