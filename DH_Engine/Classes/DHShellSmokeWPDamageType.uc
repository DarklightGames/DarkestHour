//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellSmokeWPDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.PlayerFireKill'
    DeathString="%o was burned by white phosphorus that %k launched."
    MaleSuicide="%o burned himself to a crisp."
    FemaleSuicide="%o burned herself to a crisp."
    bLocationalHit=false
    GibModifier=0.0

    TankDamageModifier=0.0
    VehicleMomentumScaling=1.0
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
}
