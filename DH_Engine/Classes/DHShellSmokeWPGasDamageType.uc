//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

    DeathOverlayMaterial=none
    DamageOverlayMaterial=none

    bArmorStops=false
    FlashFog=(X=312.500000,Y=468.7500000,Z=468.7500000)
    bCausesBlood=false

    TankDamageModifier=0.0
    VehicleDamageScaling=0.0
    VehicleMomentumScaling=1.0
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
}
