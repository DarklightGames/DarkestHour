//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHShellSmokeWPGasDamageType extends DHShellExplosionDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.mine'
    DeathString="%o was choked by white phosphorus that %k launched."
    MaleSuicide="%o choked himself to death on white phosphorus."
    FemaleSuicide="%o choked herself to death on white phosphorus."
    bLocationalHit=false
    GibModifier=0.0

    TankDamageModifier=0.0
    VehicleMomentumScaling=1.0
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
}
